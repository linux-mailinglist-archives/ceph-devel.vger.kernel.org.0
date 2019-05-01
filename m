Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7926710D9E
	for <lists+ceph-devel@lfdr.de>; Wed,  1 May 2019 21:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfEAT7D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 May 2019 15:59:03 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:40816 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEAT7D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 May 2019 15:59:03 -0400
Received: by mail-qt1-f178.google.com with SMTP id y49so15501576qta.7
        for <ceph-devel@vger.kernel.org>; Wed, 01 May 2019 12:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xwIwsaTDAFI2tDjstWyz2Cb4KdrifSjTmyXt+4ePyck=;
        b=bOCX7joKK3fqgJV5YmXWjgk2sxzhqMe8HCS8wyPDESRJU/4gzUuTIu4agATj/EQ2iB
         iD+9noPbJYqKCP5No4l1k88zQsobuyEpbfkbw8jW8QfXcHIYe+lSspx4gqtTtulBNmIe
         wDTA33T2NMErUliaYt7z/2K2iJYFGkfus++/33kMBS1tFvJA4UpZo2qfFnXKm6B9wDQp
         I7G5tU14rJryeGhzr5Y38Lww7/xvzs4rbyZ+vAJnm9PFE9k/lpCMH4LnYNnYY6Y9qPLK
         Vf7dOThwuqB572MF7IDE62Dp4TJn4TNfjEgj8pu/gqkVc8JrwUgcXiDWfP3wyDfwhpNE
         DDNQ==
X-Gm-Message-State: APjAAAXnpWih8YzM+ZkCIKG+WTYaWYm45He7zlTYJGBnp4RDqmVXCJ2O
        TJOTTqtlotBtTYKRona5jwgecnY072I=
X-Google-Smtp-Source: APXvYqwemizqGkFVEKjVve0XYydXyhoxpMSM5hMGlcGnzrW4KjV7H6q7Qf2boiYan3G9TFR0j6Qm2w==
X-Received: by 2002:aed:2282:: with SMTP id p2mr61255560qtc.334.1556740741723;
        Wed, 01 May 2019 12:59:01 -0700 (PDT)
Received: from [10.17.151.126] ([12.118.3.106])
        by smtp.gmail.com with ESMTPSA id n58sm11375860qtf.22.2019.05.01.12.59.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 12:59:00 -0700 (PDT)
Subject: Re: rgw: bucket deletion in multisite
To:     Yehuda Sadeh-Weinraub <ysadehwe@redhat.com>
Cc:     The Sacred Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>
References: <564241c1-2cf3-2452-cb21-e32ec9cd5211@redhat.com>
 <CADRKj5T5--b0dTKpg9HzoWT5UC7qGDYibmgX9Je8y5J9s87dog@mail.gmail.com>
From:   Casey Bodley <cbodley@redhat.com>
Message-ID: <ac906c52-3005-48e4-f294-06376e4957ad@redhat.com>
Date:   Wed, 1 May 2019 15:58:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CADRKj5T5--b0dTKpg9HzoWT5UC7qGDYibmgX9Je8y5J9s87dog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/30/19 9:16 PM, Yehuda Sadeh-Weinraub wrote:
> See my comments below. In general the plan looks good to me.
>
> Yehuda
>
> On Tue, Apr 30, 2019 at 1:42 PM Casey Bodley <cbodley@redhat.com> wrote:
>> Hi rgw folks, this is a rough design for cleanup of deleted buckets in
>> multisite. I would love some review/feedback.
>>
>> Motivation:
>>       - Bucket deletion in a multisite configuration does not delete
>> bucket instance metadata, bucket sync status, or bucket index objects on
>> any zone. This allows bucket sync on each zone to finish processing
>> object deletions and (hopefully) converge on empty.
>>
>> Requirements:
>>       - Remove all objects associated with deleted buckets in a timely
>> manner:
>>           - bucket instance metadata, bucket index shards, and bucket
>> sync status
>>           - all object data
>>       - Does not rely on bucket sync to delete all objects [zone A may
>> delete an empty bucket that hasn't yet synced objects from zone B, so
>> the zones would converge on zone B's objects]
>>       - Strategy to clean up already-deleted buckets, ie 'radosgw-admin
>> bucket stale-instances rm' command
>>
>> Summary:
>>       - Add a process for 'deferred bucket deletion', where local bucket
>> instance metadata is removed and the bucket index/data are scheduled for
>> later 'bucket gc'. A new 'bucket gc list' is stored in omap and
>> processed by a worker similar to existing gc.
>>       - For metadata sync, the metadata log format needs to be extended
>> to distinguish between normal writes and deletion events on bucket
>> instances. When metadata sync encounters a bucket instance deletion, it
>> runs 'deferred bucket deletion'.
>>       - Data sync on the bucket needs to avoid creating new objects while
>> bucket gc is running.
>>
>> mdlog:
>>       - entries must distinguish between Write, Remove, and Delete (where
>> Delete implies gc of associated data)
>>       - a 'bucket rm' Deletes its bucket instance metadata
>>       - a 'bucket reshard' Removes the old bucket instance because the
>> new bucket instance still owns the data
>>
>> Bucket gc list:
>>       - stored in omap in the log pool
>>       - sharded over multiple objects
>>       - each entry encodes RGWBucketInfo (needed to delete objects after
>> bucket instance is deleted)
>>
>> Bucket index:
>>       - add REMOVE_ONLY flag to bucket index to prevent object creation
>> from racing with bucket gc
>>
>> Deferred bucket delete:
>>       - flag bucket index shards as REMOVE_ONLY
>>       - add to 'bucket gc' list (entry includes encoded RGWBucketInfo)
>> *requires access to existing bucket instance metadata*
>>       - delete local bucket instance (add Delete entry to mdlog)
>>
>> Metadata sync:
>>       - must serialize sync of mdlog entries with the same metadata key,
>> to preserve order of Writes vs Removes/Deletes
>>           - can skip Writes if they're followed by Removes/Deletes
>>       - on Delete of bucket instance, run deferred bucket delete
>>       - backward compatibility: what to do with mdlog entries that don't
>> specify Write/Remove/Delete?
>>           - for bucket instance: assume write (because we never deleted
>> them before upgrade), and just try to fetch
>>           - for other metadata: use existing strategy to fetch remote
>> metadata, and remove local metadata on 404/ENOENT
>>
>> Bucket sync:
>>       - bucket sync first fetches bucket instance - on ENOENT, exit
>> bucket sync with success
>>       - if sync_object() returns REMOVE_ONLY error from bucket index,
>> exit bucket sync with success
>>       - read/fetch bucket instance metadata before taking lease to avoid
>> recreating bucket sync status objects
>>
>> Bucket gc worker:
>>       - for each bucket in gc list:
>>           - decode RGWBucketInfo
>>           - delete each object in bucket [should we GC tail objects or
>> delete inline?]
> Do you store progress anywhere? Object removal should probably avoid
> touching the bucket indexes. What if there are a zillion objects in
> the bucket? You don't want it to start from the beginning if the
> process was stopped in the middle. I think not involving the gc would
> be more efficient and less risky as otherwise you might be risking
> flooding the gc omaps, but you'll need to keep a marker somewhere.
> Also, will need to do this asynchronously with a configurable number
> of concurrent operations.

Okay. I was planning to rely on the bucket index to track progress. The 
assumption was that the buckets would have very few objects in general, 
because they had to be empty on one zone in order to delete them. 
Similarly, I was hoping to avoid the complexity of concurrency within a 
bucket index shard.

But because a) zillion-object cases are possible when sync is far enough 
behind, and b) large single-sharded buckets are more likely in 
multisite, I agree that we do need these optimizations here.

And by avoiding bucket index ops during bucket gc, the proposed 
REMOVE_ONLY flag on the bucket index could be more general (ie READONLY) 
and easier to implement.

>>           - delete incomplete multiparts
>>           - delete bucket index objects
>>           - delete bucket sync status objects
>>
>> radosgw-admin bucket stale-instances rm:
>>       - run deferred bucket delete on each bucket instance that:
>>           - does not have an associated bucket entrypoint
> You need to be careful not to remove newly created bucket instances.
>
>>           - has a bucket id matching its bucket marker? (has not been
>> resharded)
> Why? You can check for any bucket instance whether it's current by
> going to the corresponding bucket meta. In any case all of this is
> racy so need to put appropriate guards.

Yeah, this is gonna be tricky - I don't think either of my two bullet 
points are correct here. The important part is to distinguish between a 
non-current bucket instance that was resharded, and one that was 
removed. It looks we can rely on the RGWBucketInfo::reshard_status for 
this (status=DONE for reshard, and NONE for remove).

