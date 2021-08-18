Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A153F048B
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 15:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbhHRNXq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 09:23:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236629AbhHRNXp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 09:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629292990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Px62/SpxW9aMMk3v+6hNRQ6Mx3XVHNoTlGnFuHiwI8=;
        b=HVpHZnKqzXvGqnQRK2pORTK8AjRh38AvMfJJB3zPlK5I3oJJ9hw217JwQ/P6neTzqVfQM9
        TPp8Dp9hXmM9x7CqfoA+QcqUBXW184s5rJW944RWyZ/dgX9CUoFvdMgH042lOyhJFKZ2Pb
        0Ri65iVNeMUrh27Ob8P9E1RPodhNU2w=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-dG6laDKbP0KZtG7-iurPwA-1; Wed, 18 Aug 2021 09:23:08 -0400
X-MC-Unique: dG6laDKbP0KZtG7-iurPwA-1
Received: by mail-qv1-f71.google.com with SMTP id u8-20020a0cec880000b029035825559ec4so2115090qvo.22
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 06:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6Px62/SpxW9aMMk3v+6hNRQ6Mx3XVHNoTlGnFuHiwI8=;
        b=PtgGvYligTvRwVdSGPahdG4+Bw0sUTCSlS/4Kzy1T8wpCXuxd/Wl85oiE2FfhyiZdV
         14WHBIjUtabEl09LzsN03ZiPILjZfnXEEic4Vv+GUV0ieOh87JaesyYIbAYYcxwncqP3
         gFO4XDsSZtXk8f3K3vHsZqAMOMDEOwu5r4Df5VPqbZg5mugkfJHWV/+GnwV0chJE3p6L
         NdsTlRaJXaMiYkmPwCMHl35zBUVgGNhUNJQV2quJOaY0yKI28cRehyZSQahbZcUhp1+/
         x+MWu1Uzy6MMht42fPBuxG3ZYYfyF+OgkyxyUD5pvIACfXo/VAcxQ1qLupvDt+SgOVtP
         1n0w==
X-Gm-Message-State: AOAM530Acornh01JMItHDEvLM/SR9ZNmNSeoALHHjXL3aqwo279vmMeo
        1nm9UYkTSRsaNoUYEDN7ZvpYtfXzpTkR024o9cJSdZf8NjJ+c5ZkgHOJXpNlMfquuInDu0//gLT
        u7bhoPeOMs8KnzFuyXevOPA==
X-Received: by 2002:a37:d2c6:: with SMTP id f189mr7137117qkj.275.1629292988361;
        Wed, 18 Aug 2021 06:23:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6AHFTx3g5cUuWIF9FyKbj13zIPNyq9yoVV2vRaZmiZxvbRD1YjEAFNCEHT1l94ke0Cqc+nQ==
X-Received: by 2002:a37:d2c6:: with SMTP id f189mr7137067qkj.275.1629292987783;
        Wed, 18 Aug 2021 06:23:07 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id h2sm3729661qkf.106.2021.08.18.06.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 06:23:07 -0700 (PDT)
Message-ID: <49aa1afd9effe8e5cb69ff5927550a49dcf9d240.camel@redhat.com>
Subject: Re: [RFC 0/2] ceph: add debugfs entries signifying new mount syntax
 support
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Wed, 18 Aug 2021 09:23:06 -0400
In-Reply-To: <CACPzV1niGaDtZfmVi8C4uQex1UhSkyc7GGEj0Q6Ln1qRufRGdg@mail.gmail.com>
References: <20210818060134.208546-1-vshankar@redhat.com>
         <68e7fb33b9ed652847a95af49f38654780fdbe20.camel@redhat.com>
         <CACPzV1niGaDtZfmVi8C4uQex1UhSkyc7GGEj0Q6Ln1qRufRGdg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-18 at 18:47 +0530, Venky Shankar wrote:
> On Wed, Aug 18, 2021 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > On Wed, 2021-08-18 at 11:31 +0530, Venky Shankar wrote:
> > > [This is based on top of new mount syntax series]
> > > 
> > > Patrick proposed the idea of having debugfs entries to signify if
> > > kernel supports the new (v2) mount syntax. The primary use of this
> > > information is to catch any bugs in the new syntax implementation.
> > > 
> > > This would be done as follows::
> > > 
> > > The userspace mount helper tries to mount using the new mount syntax
> > > and fallsback to using old syntax if the mount using new syntax fails.
> > > However, a bug in the new mount syntax implementation can silently
> > > result in the mount helper switching to old syntax.
> > > 
> > 
> > Is this a known bug you're talking about or are you just speculating
> > about the potential for bugs there?
> 
> Potential bugs.
> 
> > 
> > > So, the debugfs entries can be relied upon by the mount helper to
> > > check if the kernel supports the new mount syntax. Cases when the
> > > mount using the new syntax fails, but the kernel does support the
> > > new mount syntax, the mount helper could probably log before switching
> > > to the old syntax (or fail the mount altogether when run in test mode).
> > > 
> > > Debugfs entries are as follows::
> > > 
> > >     /sys/kernel/debug/ceph/
> > >     ....
> > >     ....
> > >     /sys/kernel/debug/ceph/dev_support
> > >     /sys/kernel/debug/ceph/dev_support/v2
> > >     ....
> > >     ....
> > > 
> > > Note that there is no entry signifying v1 mount syntax. That's because
> > > the kernel still supports mounting with old syntax and older kernels do
> > > not have debug entries for the same.
> > > 
> > > Venky Shankar (2):
> > >   ceph: add helpers to create/cleanup debugfs sub-directories under
> > >     "ceph" directory
> > >   ceph: add debugfs entries for v2 (new) mount syntax support
> > > 
> > >  fs/ceph/debugfs.c            | 28 ++++++++++++++++++++++++++++
> > >  fs/ceph/super.c              |  3 +++
> > >  fs/ceph/super.h              |  2 ++
> > >  include/linux/ceph/debugfs.h |  3 +++
> > >  net/ceph/debugfs.c           | 26 ++++++++++++++++++++++++--
> > >  5 files changed, 60 insertions(+), 2 deletions(-)
> > > 
> > 
> > I'm not a huge fan of this approach overall as it requires that you have
> > access to debugfs, and that's not guaranteed to be available everywhere.
> > If you want to add this for debugging purposes, that's fine, but I don't
> > think you want the mount helper to rely on this infrastructure.
> 
> Right. The use-case here is probably to rely on it during teuthology
> tests where the mount fails (and the tests) when using the new syntax
> but the kernel has v2 syntax support.
> 
> I recall the discussion on having some sort of `--no-fallback` option
> to not fall-back to old syntax, but since we have the debugfs entries,
> we may as well rely on those (at least for testing).
> 

Ok, I think that sounds reasonable.

-- 
Jeff Layton <jlayton@redhat.com>

