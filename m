Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98439103AA
	for <lists+ceph-devel@lfdr.de>; Wed,  1 May 2019 03:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfEABQf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Apr 2019 21:16:35 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:42421 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfEABQf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Apr 2019 21:16:35 -0400
Received: by mail-oi1-f175.google.com with SMTP id k9so9863277oig.9
        for <ceph-devel@vger.kernel.org>; Tue, 30 Apr 2019 18:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J1PS0SfW+2BiIqk6VMTUUTTopcDMNFjvuuhoz+tlRtE=;
        b=aHFB2SrHX5NSc2mCaSX2v8/lfrH+matxVg2D9Scrh7enPxHh9hKKVKFEF40x6sbNkc
         mTggxadcidDPV6IY3WNln84IZkaz6tr6mfog4UJJaQB5wKimrypHMBIiiyL1J7Va6qsy
         OT6xtPBzcZ0G0HUaEJl2/66RjQvB6BksGVRPmVZDJxm8lg0w/PufG248GPQRcw8z8dQo
         AedRm+fJMAU0K+1YLrDE4HqPNFzFwp2wiiIXv8+2HPTOXn965X4MYiFwZHE9k/A0es0L
         vqtztVR2b+GBEIQc84f9JlXUVBvxPjBflHGVHBvrAwEC88TWhrOfLvgQkA/YvM56tef+
         zvqA==
X-Gm-Message-State: APjAAAW2v35Wr0iJCdzscUnTtG7gnfGuuRt0oq2mvqdC5tuwPbTtl5xe
        bVdTKywt6leBB5xVLkfJ2zoCZptBr6x72kTelbqu0w==
X-Google-Smtp-Source: APXvYqy/TQFilQSx5lHsutS1gyCHLs2CsOIsUmotFc0x19zQSduTPw/6QCedT4qLqBG1dyGljIFvndMlp/AlvZBscXw=
X-Received: by 2002:aca:3f83:: with SMTP id m125mr5387348oia.60.1556673394282;
 Tue, 30 Apr 2019 18:16:34 -0700 (PDT)
MIME-Version: 1.0
References: <564241c1-2cf3-2452-cb21-e32ec9cd5211@redhat.com>
In-Reply-To: <564241c1-2cf3-2452-cb21-e32ec9cd5211@redhat.com>
From:   Yehuda Sadeh-Weinraub <ysadehwe@redhat.com>
Date:   Tue, 30 Apr 2019 18:16:23 -0700
Message-ID: <CADRKj5T5--b0dTKpg9HzoWT5UC7qGDYibmgX9Je8y5J9s87dog@mail.gmail.com>
Subject: Re: rgw: bucket deletion in multisite
To:     Casey Bodley <cbodley@redhat.com>
Cc:     The Sacred Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

See my comments below. In general the plan looks good to me.

Yehuda

On Tue, Apr 30, 2019 at 1:42 PM Casey Bodley <cbodley@redhat.com> wrote:
>
> Hi rgw folks, this is a rough design for cleanup of deleted buckets in
> multisite. I would love some review/feedback.
>
> Motivation:
>      - Bucket deletion in a multisite configuration does not delete
> bucket instance metadata, bucket sync status, or bucket index objects on
> any zone. This allows bucket sync on each zone to finish processing
> object deletions and (hopefully) converge on empty.
>
> Requirements:
>      - Remove all objects associated with deleted buckets in a timely
> manner:
>          - bucket instance metadata, bucket index shards, and bucket
> sync status
>          - all object data
>      - Does not rely on bucket sync to delete all objects [zone A may
> delete an empty bucket that hasn't yet synced objects from zone B, so
> the zones would converge on zone B's objects]
>      - Strategy to clean up already-deleted buckets, ie 'radosgw-admin
> bucket stale-instances rm' command
>
> Summary:
>      - Add a process for 'deferred bucket deletion', where local bucket
> instance metadata is removed and the bucket index/data are scheduled for
> later 'bucket gc'. A new 'bucket gc list' is stored in omap and
> processed by a worker similar to existing gc.
>      - For metadata sync, the metadata log format needs to be extended
> to distinguish between normal writes and deletion events on bucket
> instances. When metadata sync encounters a bucket instance deletion, it
> runs 'deferred bucket deletion'.
>      - Data sync on the bucket needs to avoid creating new objects while
> bucket gc is running.
>
> mdlog:
>      - entries must distinguish between Write, Remove, and Delete (where
> Delete implies gc of associated data)
>      - a 'bucket rm' Deletes its bucket instance metadata
>      - a 'bucket reshard' Removes the old bucket instance because the
> new bucket instance still owns the data
>
> Bucket gc list:
>      - stored in omap in the log pool
>      - sharded over multiple objects
>      - each entry encodes RGWBucketInfo (needed to delete objects after
> bucket instance is deleted)
>
> Bucket index:
>      - add REMOVE_ONLY flag to bucket index to prevent object creation
> from racing with bucket gc
>
> Deferred bucket delete:
>      - flag bucket index shards as REMOVE_ONLY
>      - add to 'bucket gc' list (entry includes encoded RGWBucketInfo)
> *requires access to existing bucket instance metadata*
>      - delete local bucket instance (add Delete entry to mdlog)
>
> Metadata sync:
>      - must serialize sync of mdlog entries with the same metadata key,
> to preserve order of Writes vs Removes/Deletes
>          - can skip Writes if they're followed by Removes/Deletes
>      - on Delete of bucket instance, run deferred bucket delete
>      - backward compatibility: what to do with mdlog entries that don't
> specify Write/Remove/Delete?
>          - for bucket instance: assume write (because we never deleted
> them before upgrade), and just try to fetch
>          - for other metadata: use existing strategy to fetch remote
> metadata, and remove local metadata on 404/ENOENT
>
> Bucket sync:
>      - bucket sync first fetches bucket instance - on ENOENT, exit
> bucket sync with success
>      - if sync_object() returns REMOVE_ONLY error from bucket index,
> exit bucket sync with success
>      - read/fetch bucket instance metadata before taking lease to avoid
> recreating bucket sync status objects
>
> Bucket gc worker:
>      - for each bucket in gc list:
>          - decode RGWBucketInfo
>          - delete each object in bucket [should we GC tail objects or
> delete inline?]

Do you store progress anywhere? Object removal should probably avoid
touching the bucket indexes. What if there are a zillion objects in
the bucket? You don't want it to start from the beginning if the
process was stopped in the middle. I think not involving the gc would
be more efficient and less risky as otherwise you might be risking
flooding the gc omaps, but you'll need to keep a marker somewhere.
Also, will need to do this asynchronously with a configurable number
of concurrent operations.

>          - delete incomplete multiparts
>          - delete bucket index objects
>          - delete bucket sync status objects
>
> radosgw-admin bucket stale-instances rm:
>      - run deferred bucket delete on each bucket instance that:
>          - does not have an associated bucket entrypoint

You need to be careful not to remove newly created bucket instances.

>          - has a bucket id matching its bucket marker? (has not been
> resharded)

Why? You can check for any bucket instance whether it's current by
going to the corresponding bucket meta. In any case all of this is
racy so need to put appropriate guards.

>      - must be safe to run on any zone after upgrade
