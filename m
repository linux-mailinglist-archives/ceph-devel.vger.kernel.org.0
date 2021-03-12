Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C24338D78
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Mar 2021 13:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhCLMtM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Mar 2021 07:49:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231276AbhCLMsu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 07:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615553330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMxKQC6x8gvtV07CKfP0Y+XYvk5rakyhBw6X5s1qw5U=;
        b=c3K6FnFrsCSz/bY2zhGDd1hPWkPk3RfAILHYahBOV10bPvuCZVsHzCCZE5xYNNbd5GCdiU
        UafUVndQJhNeFrlhDSbPfIaRotDnUt9rZlmdvwOdmga0mnRhWIbsA/56U75Gk8M7SFz2oB
        Aim5tkrexthYQGwrn5qZ2UsIxCtDiV8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-f9Q2ioCjMIilX7-Bm6HBSQ-1; Fri, 12 Mar 2021 07:48:48 -0500
X-MC-Unique: f9Q2ioCjMIilX7-Bm6HBSQ-1
Received: by mail-qk1-f197.google.com with SMTP id y9so17978850qki.14
        for <ceph-devel@vger.kernel.org>; Fri, 12 Mar 2021 04:48:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xMxKQC6x8gvtV07CKfP0Y+XYvk5rakyhBw6X5s1qw5U=;
        b=sDEVJF2npQ1TTy2gzu7YUIk84N1Tuca66i+NcwTRDMEXNbjBGF56G+4viowlA8felf
         jQ+HD/oZNL0FX7cki0Xem6OQ3H2hvINo35ljCTNrCpH+IaZ4uwLsVhQuzTZ6SxD83OUa
         leuoUlderhSMV3zoMWEY+ZRK2tGe4IdQ5e/2C1P18IntYOCZcu8sBf5NHGqF8tN8VF2C
         DyuePtRINhp6epXJdaXn8PmnBOgBAKl0KKQKNNE0aK+7Gugp8glOHejUEGmmheu9KC51
         YRMOjasQdSEk+5rYS9ADdrZ9e/38t31hDjh8bz2/XoOE4SyP17m8VqeZOLrxDCi1gNCN
         ylJA==
X-Gm-Message-State: AOAM532DAVshQdydkH64uQawtrz3T+q6x8wn9b3rHh7gbtd2zBT4XE2M
        KYrCS3XeWkRa1+VwlZaAntUTZr3x+6i7Qj3SZnvVyK/4XUoMruD+RYN0IxfmdjYx/WMGBRJK7zp
        e+Gp2g1fOIGjuqSJFsem47g==
X-Received: by 2002:a05:622a:193:: with SMTP id s19mr11642437qtw.366.1615553328308;
        Fri, 12 Mar 2021 04:48:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXYY9ZpJb4lRg+EQrYSY4Nb30uNlaRegQtMTNielV3cCWAffDnqZEUoPaMQbwxDjUO8NfE5A==
X-Received: by 2002:a05:622a:193:: with SMTP id s19mr11642422qtw.366.1615553328088;
        Fri, 12 Mar 2021 04:48:48 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id t188sm4281732qke.91.2021.03.12.04.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 04:48:47 -0800 (PST)
Message-ID: <c2dbc391fead002c84c07860812b689a01d2b667.camel@redhat.com>
Subject: Re: fscrypt and file truncation on cephfs
From:   Jeff Layton <jlayton@redhat.com>
To:     Gregory Farnum <gfarnum@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Date:   Fri, 12 Mar 2021 07:48:47 -0500
In-Reply-To: <CAJ4mKGaaSn67XRkBemJC0XAWBTyWN_VjgEJfT8EB1cLaokAYvQ@mail.gmail.com>
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
         <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
         <CAJ4mKGaaSn67XRkBemJC0XAWBTyWN_VjgEJfT8EB1cLaokAYvQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-03-12 at 00:43 -0800, Gregory Farnum wrote:
> On Thu, Mar 11, 2021 at 8:18 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > 
> > On Thu, Mar 11, 2021 at 8:15 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > 
> > > tl;dr version: in cephfs, the MDS handles truncating object data when
> > > inodes are truncated. This is problematic with fscrypt.
> > > 
> > > Longer version:
> > > 
> > > I've been working on a patchset to add fscrypt support to kcephfs, and
> > > have hit a problem with the way that truncation is handled. The main
> > > issue is that fscrypt uses block-based ciphers, so we must ensure that
> > > we read and write complete crypto blocks on the OSDs.
> > > 
> > > I'm currently using 4k crypto blocks, but we may want to allow this to
> > > be tunable eventually (though it will need to be smaller than and align
> > > with the OSD object size). For simplicity's sake, I'm planning to
> > > disallow custom layouts on encrypted inodes. We could consider adding
> > > that later (but it doesn't sound likely to be worthwhile).
> > > 
> > > Normally, when a file is truncated (usually via a SETATTR MDS call), the
> > > MDS handles truncating or deleting objects on the OSDs. This is done
> > > somewhat lazily in that the MDS replies to the client before this
> > > process is complete (AFAICT).
> > 
> > So I've done some more research on this and it's not that simplistic.
> > Broadly, a truncate causes the following to happen:
> > 
> > - Revoke all write caps (but not Fcb) from clients.
> > 
> > - Journal the truncate operation.
> > 
> > - Respond with unsafe reply.
> > 
> > - After setattr is journalled, regrant Fs with new file size,
> > truncate_seq, truncate_size
> > 
> > - issue trunc cap update with new file size, truncate_seq,
> > truncate_size (looks redundant with prior step)
> > 
> > - actually start truncating objects above file size; concurrently
> > grant all wanted Fwb... caps wanted by client
> > 
> > - reply safe
> > 
> > From what I can tell, the clients use the truncate_seq/truncate_size
> > to avoid writing to data what the MDS plans to truncate. I haven't
> > really dug into how that works. Maybe someone more familiar with that
> > code can chime in.
> > 
> > So the MDS seems to truncate/delete objects lazily in the background
> > but it does so safely and consistently.
> 
> Right; ti's lazy in that it's not done immediately in a blocking
> manner, but it's absolutely safe. Truncate seq and size are also
> fields you can send to the OSD on read or write operations, and the
> client includes them on every op. It just has to do a (reasonably)
> simple conversion from the total truncate size the MDS gives it to
> what that means for the object being accessed (based on the striping
> pattern and object number).
> 
> I'll try and think a bit more on how to handle the special extra size
> for encryption.
> 
> ...although in my current sleep-addled state, I'm actually not sure we
> need to add any permanent storage to the MDS to handle this case! We
> can probably just extend the front-end truncate op so that it can take
> a separate "real-truncate-size" and the logical file size, can't we?

That would be one nice thing about the approach of #1. Truncating the
size downward is always done via an explicit SETATTR op (I think), so we
could just extend that with a new field for that tells the MDS where to
stop truncating.

Note that regardless of the approach we choose, the client will still
need to do a read/modify/write on the edge block before we can really
treat the truncation as "done". I'm not yet sure whether that has any
bearing on the consistency/safety of the truncation process.

-- 
Jeff Layton <jlayton@redhat.com>

