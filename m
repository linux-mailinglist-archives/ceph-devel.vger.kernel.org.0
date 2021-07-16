Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D94A3CBC11
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Jul 2021 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhGPSuH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 16 Jul 2021 14:50:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232355AbhGPSuG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 16 Jul 2021 14:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626461231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yt3PULs33YwyUPlXWU5QedaCgysEy4r06hzKiLgVBS4=;
        b=hrXoszxf45oLTbsBFNq6k/+u/z8EgDqyUG4CMUHegxcZwg46xrQwwg95RpZIXGGixBXGX0
        +rEGIq66BzFnJggdeVWiNYzfV7wkuTaxfCR0SO9FtuidIoDc3O/vyjZM0HSDLlFv21fRRa
        9pcjE08jgLTKY6/ytK+eCyuNduLKJfI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-VjeXX_l_Mwee1PQSePEY0A-1; Fri, 16 Jul 2021 14:47:09 -0400
X-MC-Unique: VjeXX_l_Mwee1PQSePEY0A-1
Received: by mail-qv1-f71.google.com with SMTP id c5-20020a0562141465b02902e2f9404330so7317366qvy.9
        for <ceph-devel@vger.kernel.org>; Fri, 16 Jul 2021 11:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yt3PULs33YwyUPlXWU5QedaCgysEy4r06hzKiLgVBS4=;
        b=Xr3Ld5kfXZoBsBM5UKgbC7pQnj/pbS/4qmUlIHmVGXNJVXXpoLvP3QodoxLYOSPIjk
         iJcLJk1wLvOXyjzWjl5RS9uDdA+RjO+asDIZlcNRDlMSkYhMHTTAzBL16snLsKfE2Vw2
         TXoBEM7RZ8TjZEDlKMkhOXvmR8rWiFNAh6K/PPSSGH/nhRNWXzZSPxqJ6riSJEQZ8G3h
         0GHYiidl8WoQ+DSwE7BDOpEMKGYEj3NdZSHg9soOLp6HecxJP3d3qcFxJchl8/Srp+6v
         V8narBe8Nc0ISBrCJGzGkry2rI/ol0wSJr8+cA5c/fNTGtC/PFv9jqYEKDAIkhYTCZX2
         RFyw==
X-Gm-Message-State: AOAM530D7Trma8rKd8FLB/840bwvDMyrwPYt8mzf2pPNLu2pIUC4YiWh
        pvyUf9qTl/7Kg+u7azulQcDcKWT+/LbChUMZECSAZmuAeet5SaKetzmaKKC91G8x8glZgkClTVb
        eo03G/jsdmGvqedvvR/HRYw==
X-Received: by 2002:ac8:73cc:: with SMTP id v12mr1580969qtp.391.1626461229391;
        Fri, 16 Jul 2021 11:47:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg26ilW8KA9n/Ofa6uiSoEFTFMHl2NjqqnkZpcPieku+HbkBFiQOJNIan2/SdUKGaydcU0IA==
X-Received: by 2002:ac8:73cc:: with SMTP id v12mr1580960qtp.391.1626461229236;
        Fri, 16 Jul 2021 11:47:09 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id bj37sm4237793qkb.78.2021.07.16.11.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 11:47:08 -0700 (PDT)
Message-ID: <75e674f7be189192a869b971f6e36da01d5ef997.camel@redhat.com>
Subject: Re: [PATCH v4 0/5] ceph: new mount device syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com,
        lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 16 Jul 2021 14:47:08 -0400
In-Reply-To: <20210714100554.85978-1-vshankar@redhat.com>
References: <20210714100554.85978-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-07-14 at 15:35 +0530, Venky Shankar wrote:
> v4:
>   - fix delimiter check in ceph_parse_ips()
>   - use __func__ in ceph_parse_ips() instead of hardcoded function name
>   - KERN_NOTICE that mon_addr is recorded but not reconnected
> 
> Venky Shankar (5):
>   ceph: generalize addr/ip parsing based on delimiter
>   ceph: rename parse_fsid() to ceph_parse_fsid() and export
>   ceph: new device mount syntax
>   ceph: record updated mon_addr on remount
>   doc: document new CephFS mount device syntax
> 
>  Documentation/filesystems/ceph.rst |  25 ++++-
>  drivers/block/rbd.c                |   3 +-
>  fs/ceph/super.c                    | 151 +++++++++++++++++++++++++++--
>  fs/ceph/super.h                    |   3 +
>  include/linux/ceph/libceph.h       |   5 +-
>  include/linux/ceph/messenger.h     |   2 +-
>  net/ceph/ceph_common.c             |  17 ++--
>  net/ceph/messenger.c               |   8 +-
>  8 files changed, 186 insertions(+), 28 deletions(-)
> 

I've gone ahead and merged these into the testing branch, though I have
not had time to personally do any testing with the new mount helper or
new syntax. It does seem to behave fine with the old mount helper and
syntax.

Venky, I did make a couple of minor changes to this patch:

    ceph: record updated mon_addr on remount

Please take a look when you have time and make sure they're OK.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

