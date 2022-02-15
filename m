Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029394B6C00
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 13:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbiBOM13 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 07:27:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbiBOM12 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 07:27:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81D2A107AAB
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 04:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644928037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EPA0emrN45sLOLoUZ83X5/DG0RI4rr9kYq9aYKrJ41A=;
        b=GLVB49uHpULGWCj8t/caOM8Ph3LivpvpxzOuF+7SruKCuKzrUYNu2MWkFaAqEG3G2kb69L
        GR1gh16zpTG61+Ztzx9f6sUyKP4EHfRwFZZA2cICp8Pe2BAdnJrAI9DPTLHFN15TZ71bEJ
        zOHBIeD+cEj2cQ6c4oUSytb8uydVEis=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-9WYOrwdkPtCFurx8fXWwuw-1; Tue, 15 Feb 2022 07:27:16 -0500
X-MC-Unique: 9WYOrwdkPtCFurx8fXWwuw-1
Received: by mail-lf1-f70.google.com with SMTP id 27-20020ac25f1b000000b0043edb7bf7e7so6092644lfq.20
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 04:27:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EPA0emrN45sLOLoUZ83X5/DG0RI4rr9kYq9aYKrJ41A=;
        b=vmYmeBr1vqNkdnYCwRbp+3TCVR2C74YB38f+tqm0pU6bvbg96U4x5MtwXFFN0HwDq1
         GwVEi01sBlk2sSCTcvsGoRAjL4uMKuqxaIFbhr45umI1p2aPDbJOUMKTk+9B/PW5alsp
         jiCL9W6KR8NIqG1bQ8XpCHEzFbmA3UZmeqvcm+Gq/Jh5A68hIPlsOf+1qlG+Mm7GnaDe
         nRVL3Prs/CMygGEMfjERn9UrW5135lnDv7WywN7lMgsh4c9Bc6+UgMOJe20oJwEUW5Fw
         WAXPrguiqUlloGDEmdNVWDyZXHjoCXfumFJLTvMQhx9bPsj7VvjPnXBvHFXffinDzmSg
         sgSw==
X-Gm-Message-State: AOAM531hfv9yvk3dMkVvg2vj1/VwQR+ywWy7ETYMmfEw8B877bl42ANR
        EFtK7IQsTNhynKYrlKSv+48/DdIdLchzxIsH7kyPJwkOQk7gnbUjJGRMaNMOj9c0BAkp2vygZIY
        G4cAzWzSij9bLIfB3/niv4yk7dz5drVYyGgDStg==
X-Received: by 2002:a2e:880a:: with SMTP id x10mr2337083ljh.310.1644928034963;
        Tue, 15 Feb 2022 04:27:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5UJZnxtdQ4xBKrk5ndZ5VI/AER9nWZrGMcAk2I4dmB/jpmoqPPFfe8DtpqFYlP/vpl9ppq1dXS5/naeXJnA0=
X-Received: by 2002:a2e:880a:: with SMTP id x10mr2337070ljh.310.1644928034746;
 Tue, 15 Feb 2022 04:27:14 -0800 (PST)
MIME-Version: 1.0
References: <20220215091657.104079-1-vshankar@redhat.com> <3f74605528367ae8935aaade101c168198e3996f.camel@redhat.com>
In-Reply-To: <3f74605528367ae8935aaade101c168198e3996f.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Tue, 15 Feb 2022 17:56:38 +0530
Message-ID: <CACPzV1n+LDTzraas9_FCU_xvdoQPMX6t3s6Y10-yPDBYFfFkHQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] ceph: forward average read/write/metadata latency
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 15, 2022 at 5:08 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 2022-02-15 at 14:46 +0530, Venky Shankar wrote:
> > Right now, cumulative read/write/metadata latencies are tracked
> > and are periodically forwarded to the MDS. These meterics are not
> > particularly useful. A much more useful metric is the average latency
> > and standard deviation (stdev) which is what this series of patches
> > aims to do.
> >
> > The userspace (libcephfs+tool) changes are here::
> >
> >           https://github.com/ceph/ceph/pull/41397
> >
> > Note that the cumulative latencies are still forwarded to the MDS but
> > the tool (cephfs-top) ignores it altogether.
> >
> > Latency standard deviation is calculated in `cephfs-top` tool.
> >
> > Venky Shankar (3):
> >   ceph: track average r/w/m latency
> >   ceph: include average/stdev r/w/m latency in mds metrics
> >   ceph: use tracked average r/w/m latencies to display metrics in
> >     debugfs
> >
> >  fs/ceph/debugfs.c |  2 +-
> >  fs/ceph/metric.c  | 44 +++++++++++++++++++++++----------------
> >  fs/ceph/metric.h  | 52 +++++++++++++++++++++++++++++++++--------------
> >  3 files changed, 65 insertions(+), 33 deletions(-)
> >
>
> Looks good, Venky. Merged into testing branch. I did make a small change
> to the last patch to fix a compiler warning. PTAL and make sure you're
> OK with it.

Looks good. Thanks for the fix.

>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

