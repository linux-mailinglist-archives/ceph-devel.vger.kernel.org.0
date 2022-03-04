Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD0C4CD515
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Mar 2022 14:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiCDNW2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Mar 2022 08:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbiCDNW1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Mar 2022 08:22:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A37DE1B756B
        for <ceph-devel@vger.kernel.org>; Fri,  4 Mar 2022 05:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646400097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n8K5y5peuALymhhF1NEujhmTUEwsXq974pf0Ve60eyA=;
        b=BbL6TaoGrh3J+eDOXW5R6kg7cicY0u8u5oisbcRRrjmFouOlADWyrFTLbyTxgStyGuFQDC
        QW80MGqXNuovSfr3oOsgGcuhr/ga8K7VOX3+sGHsLBAtsPy9jxIsMzQ8bHFBbV8MHD4gkH
        mbxm0njoFI9dqnZJTTlDWrKzWrgYf+o=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-Bzvf1ZZCMSmigxe0e_NlFA-1; Fri, 04 Mar 2022 08:21:36 -0500
X-MC-Unique: Bzvf1ZZCMSmigxe0e_NlFA-1
Received: by mail-lf1-f70.google.com with SMTP id m18-20020a0565120a9200b004439214844dso2664097lfu.9
        for <ceph-devel@vger.kernel.org>; Fri, 04 Mar 2022 05:21:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n8K5y5peuALymhhF1NEujhmTUEwsXq974pf0Ve60eyA=;
        b=im126QTfY/kSL4Nz+92ILU3I5r+NtdiEC+80x6k6AroWxjwG1pLhuk9Q2G71akRwZX
         reWEiX21yZxsnebmWUYDhpa7oOQeZXNqhDeMTI5ms+a6IJGeMACDoj4aXZV/kW0JfaA3
         y9t5TqGuHdZJsqlphiBzDST05JG7u41RgnXmOLV8X2oWu1P9Plw/6WKZCscqxThewCqg
         Z2zVF4/UKCAUQ1Lc3c5/DVas0SQskNkFGoBotsFI17+mFH7RMVAa3bT+BdIrX6DCWjQi
         hvqvyMG6JSc0RugAZtQQJLNk++JcKajCdisEqzlxtK8ZVJTs2O/Xs5CmPqWqPiR02Er0
         UpYw==
X-Gm-Message-State: AOAM532s+S28TRuLKAzPTUU/u3iTTj+qjVYKegRnQHXGVCVsNxi1RoYO
        p/4aU5ymShCMaNJpkySouKjML6QD9IR/1o+HSe0pGEJHeawcn6NfTBUyj9vllvNeY9SySD54/gv
        Jk2Ycg8oKDeCddGE7XYMUEnKOtmngphLR5GAv+g==
X-Received: by 2002:ac2:43b1:0:b0:443:b47e:7ac0 with SMTP id t17-20020ac243b1000000b00443b47e7ac0mr24248882lfl.553.1646400094802;
        Fri, 04 Mar 2022 05:21:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHBlfj+D9GG0qRZEUQIzDw47Fr3f3iCgF/HHJ97AqXBWNZj9Xx1N5cL2db8oAWDFKbBFWvsCoDo5ifoyLOg+8=
X-Received: by 2002:ac2:43b1:0:b0:443:b47e:7ac0 with SMTP id
 t17-20020ac243b1000000b00443b47e7ac0mr24248876lfl.553.1646400094593; Fri, 04
 Mar 2022 05:21:34 -0800 (PST)
MIME-Version: 1.0
References: <20220209153849.496639-1-vshankar@redhat.com> <CAOi1vP8C7q97mKFcCAb-_BAJfAg85P2mW+dmRzhw376K_v7riA@mail.gmail.com>
In-Reply-To: <CAOi1vP8C7q97mKFcCAb-_BAJfAg85P2mW+dmRzhw376K_v7riA@mail.gmail.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Fri, 4 Mar 2022 18:50:58 +0530
Message-ID: <CACPzV1kpCQL6zU=8iBOMON7C_8Av-xLE9-mSMkJEEQVm0dZDxw@mail.gmail.com>
Subject: Re: [PATCH] ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 1, 2022 at 10:32 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Wed, Feb 9, 2022 at 7:55 PM Venky Shankar <vshankar@redhat.com> wrote:
> >
> > Latencies are of type ktime_t, coverting from jiffies is incorrect.
> > Also, switch to "struct ceph_timespec" for r/w/m latencies.
> >
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  fs/ceph/metric.c | 20 ++++++++++----------
> >  fs/ceph/metric.h | 11 ++++-------
> >  2 files changed, 14 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > index 0fcba68f9a99..a9cd23561a0d 100644
> > --- a/fs/ceph/metric.c
> > +++ b/fs/ceph/metric.c
> > @@ -8,6 +8,13 @@
> >  #include "metric.h"
> >  #include "mds_client.h"
> >
> > +static void to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
>
> Hi Venky,
>
> I think ktime_to_ceph_timespec() would be a much better name.
>
> > +{
> > +       struct timespec64 t = ktime_to_timespec64(val);
> > +       ts->tv_sec = cpu_to_le32(t.tv_sec);
> > +       ts->tv_nsec = cpu_to_le32(t.tv_nsec);
>
> ceph_encode_timespec64() does this with appropriate casts, let's use
> it.

Makes sense.

BTW, this fix would be a new change I guess? (rather than sending an
updated version of the patch since it has been merged in -testing)?

>
> Thanks,
>
>                 Ilya
>


-- 
Cheers,
Venky

