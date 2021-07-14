Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996D43C87C1
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 17:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbhGNPgx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 11:36:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239903AbhGNPgY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 11:36:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626276811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Ab5U/WlVUgm0vqczzQ38hsMpgL40iLsNZEAMDHTT60=;
        b=MZ+QnF5k9GOkCagB+JGUIGkC8+rRhVKUkOPE2//7SQ7FEv6cPRcg4FA8R1N29i7m4//vQz
        ecCaha/kciNwdb0wvUjcKpQKS5VGT7zoQwp1SrYqm4rHIxoew3uXZWk8H6FnSKx8LOArM2
        jofbyYX3SVRbgtk+xgplkIzJP7VEWTk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-E1UKn_uMPiGvriBbweZuvg-1; Wed, 14 Jul 2021 11:33:29 -0400
X-MC-Unique: E1UKn_uMPiGvriBbweZuvg-1
Received: by mail-qv1-f69.google.com with SMTP id u40-20020a0cb9280000b0290290c3a9f6f1so1958718qvf.0
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 08:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/Ab5U/WlVUgm0vqczzQ38hsMpgL40iLsNZEAMDHTT60=;
        b=MWMMDuYXC9En3cGzK6rdD6YQKxEJDYoXsP7RyXIJv4lG5r+D4AE9Bl1lJkLV82naTV
         N6FaIGOLJFnKTLr2XINUmGj47E+sJ0xVk0IwPIrq5ypZ5t6/gXsgHGgY6q5/XL4dzvom
         nePGo520z8mrzDxDWp5PLt03gBk33QSq/OjTLO9CwvJY5cdzEYujsi/pTooPjhUwwR6g
         w0NH99XvEgeCshp0xqJsXL4Z2yaoTTZSpCQSCAVGCJ1YH4r0ScnbjR00w3osz5ozCkvB
         eqB8ttNtMmpS6JOofS03LKQqgE/qrf1I+mKHtKZA6jq5h9+J1D+TGBDluE8j3E93D983
         pa+A==
X-Gm-Message-State: AOAM532GrkT+UjfFKlKlLaAaeNG3eBm8DXc7JIUBFsAjrmv2TQfX31/f
        DsKg9PccRaCo3kFD2dYuxA6dTMxIBUbPiPDWfw9/GNKvVYMi+vnyrqznomx3UAVFmCk6PRSeZxq
        b/RMOMZ7NLClc874TBJdTVg==
X-Received: by 2002:a05:620a:1a08:: with SMTP id bk8mr10656665qkb.158.1626276808902;
        Wed, 14 Jul 2021 08:33:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/mRkmJv77mW34VLmoMQ4f5WcDzTfSOnDnFQ9Vzzjq1Tr995fweM5Lm3X54M/9EyM++TTYyw==
X-Received: by 2002:a05:620a:1a08:: with SMTP id bk8mr10656651qkb.158.1626276808752;
        Wed, 14 Jul 2021 08:33:28 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 5sm1199557qkr.100.2021.07.14.08.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 08:33:28 -0700 (PDT)
Message-ID: <2ac2ddfa2cc8d52800c150ed567779df935430bd.camel@redhat.com>
Subject: Re: [PATCH v4 0/5] ceph: new mount device syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com,
        lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 14 Jul 2021 11:33:26 -0400
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

This looks good, Venky. Nice work!

I'm doing a bit of testing with this now, and will plan to merge it into
the testing branch later today.
-- 
Jeff Layton <jlayton@redhat.com>

