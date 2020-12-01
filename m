Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB682CAF72
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Dec 2020 23:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403873AbgLAWAt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Dec 2020 17:00:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390818AbgLAWAm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Dec 2020 17:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606859956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8BI1oOkbQcwmPSVmDceOIU6v1rjKsZn75IV4SsZ+gbw=;
        b=GdGMJpGwcF8pnJooyd64ijlo/7ejES0fdYJviX9NFwEHqp9m1Kiv77zNl58CKoGC6gHgP1
        lx0oTskTUWx82PQiaFmPTmhBkpuhr5mAK72Qlyg+sKIm8DDo3Cgv9waio6bfxQwzkTAqWY
        A3xeVj7cp9Qemq+q2M5ERrQLUF9f/FQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-NP6-MRquNvekT_XLtnoqAQ-1; Tue, 01 Dec 2020 16:59:13 -0500
X-MC-Unique: NP6-MRquNvekT_XLtnoqAQ-1
Received: by mail-qt1-f197.google.com with SMTP id c11so2319721qtw.10
        for <ceph-devel@vger.kernel.org>; Tue, 01 Dec 2020 13:59:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8BI1oOkbQcwmPSVmDceOIU6v1rjKsZn75IV4SsZ+gbw=;
        b=tyd54EENlGH5CR96Sw6ZJN7w6oL0Qju90SFfP5FLl4Q6huqZdCnIsi5bCVH91RlTDT
         ZjAjWEYEsjOsOYfDe+/62nZwxkHWKO49Q1Wcq+7ifO3JyZDDnwSV+x4EtRJqowNk98sl
         YfE9EyCxxoyXue+2YEGKNAVHi3Tyepj/tGiI/nVi1iptKDopjDgCUlBkDsO6J27Vrf/k
         CVHj6Ouv68VViO4vLQqyJZbicU5L33dqJIn+Kjr3VYo26eteeCpmRnaEz52RRurAiOHs
         z2DY2dJ7VxXmkYQ1LTEx9fmVSDN9fb/DXPrZzdX5BeUbdtstAlN1PK2aXdg2zUYkosDU
         nt7Q==
X-Gm-Message-State: AOAM531zd5PtyQDDwufpr3VnSsec7gONHTVCddnywEeqNPZnb2kTDzdU
        fMaBypWOMINi337HNy6FqF6SL/QVSATOKCldbUSgydKPBLqMwsTRWsLtOPfryhaynb/Vm5Q4kEw
        ZaCfNTS2/O5miYSZK7dXuEQ==
X-Received: by 2002:ac8:4a92:: with SMTP id l18mr4999942qtq.212.1606859953291;
        Tue, 01 Dec 2020 13:59:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZAl8tM5iyaNNc9mrHp/Qna9L6Fkd4Rmo3Z7tNY2UWnCZuXzlKO38R7TE95DOnO6Vooo4oTw==
X-Received: by 2002:ac8:4a92:: with SMTP id l18mr4999927qtq.212.1606859953108;
        Tue, 01 Dec 2020 13:59:13 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id v15sm1006832qto.74.2020.12.01.13.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 13:59:12 -0800 (PST)
Message-ID: <7932a1f8d8886bed0a27bb4214cadd20a91fbc29.camel@redhat.com>
Subject: Re: provisioning clients in teuthology with an extra local
 filesystem
From:   Jeff Layton <jlayton@redhat.com>
To:     David Galloway <dgallowa@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        sepia <sepia@ceph.io>
Date:   Tue, 01 Dec 2020 16:59:11 -0500
In-Reply-To: <baea4c8b-7d5c-fc62-8a0a-fc2d77b2edf4@redhat.com>
References: <36b421ea14b3b14226b3e7c0407876886bb74e08.camel@redhat.com>
         <ad5a9630-daa0-b379-c7f4-5a9a139cd3a5@redhat.com>
         <aa38cc3b2ed96fed0dbee443fed564ac8d1a151d.camel@redhat.com>
         <0cdca09a-0c7d-66b6-f3d7-02b7a36410a2@redhat.com>
         <a4df6b959a978c5a6c76efce731a14a747e9fa49.camel@redhat.com>
         <baea4c8b-7d5c-fc62-8a0a-fc2d77b2edf4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-12-01 at 16:31 -0500, David Galloway wrote:
> On 12/1/20 3:07 PM, Jeff Layton wrote:
> > On Tue, 2020-12-01 at 14:23 -0500, David Galloway wrote:
> > > 
> > > On 12/1/20 10:24 AM, Jeff Layton wrote:
> > > > On Tue, 2020-12-01 at 10:22 -0500, David Galloway wrote:
> > > > > On 12/1/20 9:55 AM, Jeff Layton wrote:
> > > > > > I've been working on a patch series to overhaul the fscache code in the
> > > > > > kclient. I also have this (really old) tracker to add fscache testing to
> > > > > > teuthology:
> > > > > > 
> > > > > >     https://tracker.ceph.com/issues/6373
> > > > > > 
> > > > > > It would be ideal if the clients in such testing had a dedicated
> > > > > > filesystem mounted on /var/cache/fscache, so that if it fills up it
> > > > > > doesn't take down the rootfs with it. We'll also need to have
> > > > > > cachefilesd installed and running in the client hosts.
> > > > > > 
> > > > > > Is it possible to do this in teuthology? How would I approach this?
> > > > > > 
> > > > > 
> > > > > I think I can make this happen pretty easily in ceph-cm-ansible.  What
> > > > > I'd need from you is desired filesystem type and size.  Once I'm done
> > > > > with my end, we'll need to create a cephlab.ansible overrides yaml
> > > > > fragment to stick in that suite's qa directory.
> > > > > 
> > > > 
> > > > Ok, cool:
> > > > 
> > > > fstype: xfs or ext4 (either is fine)
> > > > size: ~50g or so would be ideal, but we can probably get away with less 
> > > >       if necessary
> > > > 
> > > 
> > > Getting there...
> > > 
> > > https://github.com/ceph/ceph-cm-ansible/pull/592
> > > 
> > > Can you give me an optimal cachefilesd.conf and I'll set that up in
> > > ceph-cm-ansible too?
> > > 
> > 
> > I never actually tweak the defaults in my local testing, so let's start
> > with a default cachefilesd.conf as installed by the package. If we need
> > to tweak it later, then we'll go from there.
> > 
> 
> K.  I made it optional and used the package-provided defaults.
> 
> Your requested changes are implemented in ceph-cm-ansible.  I've
> attached the yaml fragments you'll need to pass on the
> `teuthology-suite` command line to set up the partition, filesystem, and
> cachefilesd service.
> 
> e.g., teuthology-suite ... ~/fs-cache-smithi.yml

Many thanks! I now need to figure out how to pass arbitrary mount
options to the kclient. I think that might need some plumbing down in
ceph/qa. I'll sort that out soon and test this.

Cheers!
-- 
Jeff Layton <jlayton@redhat.com>

