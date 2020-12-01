Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C246D2CAD09
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Dec 2020 21:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404395AbgLAUJU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Dec 2020 15:09:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389130AbgLAUJT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Dec 2020 15:09:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606853273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=02Cpn2gzLkah5tSHJCWs5s3F1OZBhcPdd+7rEBXgx8Q=;
        b=A6Zzt4kCf9D/Vg5N7eXOOjXGUQSmG+GoG2+Rt9yodliaWzGtSmKQJKrbNYhB0P7BG5rqkN
        rACoRzFIQXg4bQegyQyr8Crh2KCbXSGuvIfz/nGHHaUN2bJ+5pBk2tVpthms2O/6Jq0+R5
        HUBGDUCAMikfXVZwmIdKGNdv/3PiByE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-aesQeyj6PumjisfGmTbsWg-1; Tue, 01 Dec 2020 15:07:51 -0500
X-MC-Unique: aesQeyj6PumjisfGmTbsWg-1
Received: by mail-qv1-f69.google.com with SMTP id ca17so2051462qvb.1
        for <ceph-devel@vger.kernel.org>; Tue, 01 Dec 2020 12:07:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=02Cpn2gzLkah5tSHJCWs5s3F1OZBhcPdd+7rEBXgx8Q=;
        b=aMd8yJkfh6k+xHq+gH8vXpdN9F8KR404uDhsOcu5BuA4CRKc8+u0dLDYDJWj8FQFth
         XQ7QlCkrZcth6UfBywluLS0Wa0Qi92bOr+OLBHdreCwm07pU8YvLXkbVeWRQrEaRKmTK
         JDnXMKYM9rb4Ctcyhl7jtD3140pxy4m2wWV5NK5Eh+IXWiXwNZ+IduZYQYZ1oRCGHI2w
         mlWQf+iwwZzCMDf9CAdO8GJUBAMYE19m29tjR49GeLm6ICQtnfHm5/MeSOZa+Y0AwmkL
         ryaAnjes7mAlj7OwvYJU1ryYN1Oxw/CijMD3FjwW5/iDchA5S/46q9+ZXW8tNVNkK9JT
         bR5Q==
X-Gm-Message-State: AOAM533RyjTGvpqftaUGiiZanIqryRZcgzsoeKE4AggAm+CyoxdtlI8a
        FSCgGBZSxjYfuE5RPq9+j7jMVHK2FedODivCuj8z8UHmaf59Fmmt57EIEytpD8/vA8TnfLszT3Q
        qKetUrF1k0w6m1zRUXPtP3A==
X-Received: by 2002:a05:620a:b0e:: with SMTP id t14mr4666595qkg.484.1606853267827;
        Tue, 01 Dec 2020 12:07:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvbPUp8R4JdF1IZipKY2MI4WMTSkw10s8FUxzU8P54suUidRnl52BC2pDi/B12MdPszSRJoA==
X-Received: by 2002:a05:620a:b0e:: with SMTP id t14mr4666581qkg.484.1606853267609;
        Tue, 01 Dec 2020 12:07:47 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id c27sm691087qkk.57.2020.12.01.12.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 12:07:47 -0800 (PST)
Message-ID: <a4df6b959a978c5a6c76efce731a14a747e9fa49.camel@redhat.com>
Subject: Re: provisioning clients in teuthology with an extra local
 filesystem
From:   Jeff Layton <jlayton@redhat.com>
To:     David Galloway <dgallowa@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        sepia <sepia@ceph.io>
Date:   Tue, 01 Dec 2020 15:07:45 -0500
In-Reply-To: <0cdca09a-0c7d-66b6-f3d7-02b7a36410a2@redhat.com>
References: <36b421ea14b3b14226b3e7c0407876886bb74e08.camel@redhat.com>
         <ad5a9630-daa0-b379-c7f4-5a9a139cd3a5@redhat.com>
         <aa38cc3b2ed96fed0dbee443fed564ac8d1a151d.camel@redhat.com>
         <0cdca09a-0c7d-66b6-f3d7-02b7a36410a2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-12-01 at 14:23 -0500, David Galloway wrote:
> 
> On 12/1/20 10:24 AM, Jeff Layton wrote:
> > On Tue, 2020-12-01 at 10:22 -0500, David Galloway wrote:
> > > On 12/1/20 9:55 AM, Jeff Layton wrote:
> > > > I've been working on a patch series to overhaul the fscache code in the
> > > > kclient. I also have this (really old) tracker to add fscache testing to
> > > > teuthology:
> > > > 
> > > >     https://tracker.ceph.com/issues/6373
> > > > 
> > > > It would be ideal if the clients in such testing had a dedicated
> > > > filesystem mounted on /var/cache/fscache, so that if it fills up it
> > > > doesn't take down the rootfs with it. We'll also need to have
> > > > cachefilesd installed and running in the client hosts.
> > > > 
> > > > Is it possible to do this in teuthology? How would I approach this?
> > > > 
> > > 
> > > I think I can make this happen pretty easily in ceph-cm-ansible.  What
> > > I'd need from you is desired filesystem type and size.  Once I'm done
> > > with my end, we'll need to create a cephlab.ansible overrides yaml
> > > fragment to stick in that suite's qa directory.
> > > 
> > 
> > Ok, cool:
> > 
> > fstype: xfs or ext4 (either is fine)
> > size: ~50g or so would be ideal, but we can probably get away with less 
> >       if necessary
> > 
> 
> Getting there...
> 
> https://github.com/ceph/ceph-cm-ansible/pull/592
> 
> Can you give me an optimal cachefilesd.conf and I'll set that up in
> ceph-cm-ansible too?
> 

I never actually tweak the defaults in my local testing, so let's start
with a default cachefilesd.conf as installed by the package. If we need
to tweak it later, then we'll go from there.

Thanks!
-- 
Jeff Layton <jlayton@redhat.com>

