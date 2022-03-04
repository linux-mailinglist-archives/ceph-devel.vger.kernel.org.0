Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388E54CD537
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Mar 2022 14:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbiCDNeS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Mar 2022 08:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiCDNeR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Mar 2022 08:34:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 035351B762C
        for <ceph-devel@vger.kernel.org>; Fri,  4 Mar 2022 05:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646400809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZNttvbAR7j/1OBjCm6GpJPMuPmyKeIhGgD2f8j2Zmc=;
        b=Y/wlPUnzPcAHVy9VVtbQIZLD0p+JXWgqKX7bpNLsKoDSg6sS++oZ6XDNkOMpgMW14SAYTR
        AEb0SkS7iKLJheBb6yN2CxejSPBriLFXusej6Ay2Y40kQy1hVwX/8k++cNGp91B0sXDewS
        Bp2H2kpcqDxlXFMdPgkMDApcqZ2Zr2I=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-YUl9lKf2O7GLrzVHISOI-A-1; Fri, 04 Mar 2022 08:33:27 -0500
X-MC-Unique: YUl9lKf2O7GLrzVHISOI-A-1
Received: by mail-qt1-f200.google.com with SMTP id g11-20020ac842cb000000b002dd2c58affaso6018402qtm.12
        for <ceph-devel@vger.kernel.org>; Fri, 04 Mar 2022 05:33:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WZNttvbAR7j/1OBjCm6GpJPMuPmyKeIhGgD2f8j2Zmc=;
        b=OyiLvE68BLJHFO86oGDdlSHl6b1KNR1KaDddeAj6k/FPYV6oruAU9+dT85I5EHs815
         3mQKqvKdWVb0HvQsR73JFLT13WAjTZPVP2/9TcjeK1Aq/4HcyRS/lJDj3/4/cs2ACHKw
         3GnDd9kByq6G1OTRwqecYMZQVgxOKAdHFf2OqX9hCwMry1JTo/BXV9ogo9Hbg+qm0Caz
         1XalH64U2HEberswelhoyoFfpHjd1cbSpJQ4J+AUPyED3So3vyHYnJYBOvfyHb5Jx5fT
         t5TuuWjMURUy6QffNJXRLN0HUVB+oNt9e1134u9rob2sqo3xdTVFbf3WiFvUXbBAtXAM
         rGoA==
X-Gm-Message-State: AOAM530aoVN9Sfe/xq9BdOHU6+znLmRm/Oyi206zXAOFhRT1nPH8nbIy
        np0QDPtzRPHwJzhK5l0CUi3TylHda62I56YpGAFSxyBiCn+cwhcJrzcZOsJY5mCD/eIZ6mV+WP+
        GhY47vVZYvwAtKF9ngAeKkA==
X-Received: by 2002:ad4:5505:0:b0:435:692:e797 with SMTP id az5-20020ad45505000000b004350692e797mr12221813qvb.19.1646400807494;
        Fri, 04 Mar 2022 05:33:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxeqQUOfi23SjCSfpepXfYiOQrGMs36TnjU6CWS+stnNdBwc1wUsRmdH0XYkRfUeyVX0Y7+pg==
X-Received: by 2002:ad4:5505:0:b0:435:692:e797 with SMTP id az5-20020ad45505000000b004350692e797mr12221801qvb.19.1646400807309;
        Fri, 04 Mar 2022 05:33:27 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id d12-20020a05620a158c00b00648ec3fcbdfsm2358318qkk.72.2022.03.04.05.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 05:33:26 -0800 (PST)
Message-ID: <f4ecdafb9d738e661cd4488c0178dc6f49511408.camel@redhat.com>
Subject: Re: [PATCH] ceph: use ktime_to_timespec64() rather than
 jiffies_to_timespec64()
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 04 Mar 2022 08:33:25 -0500
In-Reply-To: <CACPzV1kpCQL6zU=8iBOMON7C_8Av-xLE9-mSMkJEEQVm0dZDxw@mail.gmail.com>
References: <20220209153849.496639-1-vshankar@redhat.com>
         <CAOi1vP8C7q97mKFcCAb-_BAJfAg85P2mW+dmRzhw376K_v7riA@mail.gmail.com>
         <CACPzV1kpCQL6zU=8iBOMON7C_8Av-xLE9-mSMkJEEQVm0dZDxw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-03-04 at 18:50 +0530, Venky Shankar wrote:
> On Tue, Mar 1, 2022 at 10:32 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > 
> > On Wed, Feb 9, 2022 at 7:55 PM Venky Shankar <vshankar@redhat.com> wrote:
> > > 
> > > Latencies are of type ktime_t, coverting from jiffies is incorrect.
> > > Also, switch to "struct ceph_timespec" for r/w/m latencies.
> > > 
> > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > ---
> > >  fs/ceph/metric.c | 20 ++++++++++----------
> > >  fs/ceph/metric.h | 11 ++++-------
> > >  2 files changed, 14 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > > index 0fcba68f9a99..a9cd23561a0d 100644
> > > --- a/fs/ceph/metric.c
> > > +++ b/fs/ceph/metric.c
> > > @@ -8,6 +8,13 @@
> > >  #include "metric.h"
> > >  #include "mds_client.h"
> > > 
> > > +static void to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
> > 
> > Hi Venky,
> > 
> > I think ktime_to_ceph_timespec() would be a much better name.
> > 
> > > +{
> > > +       struct timespec64 t = ktime_to_timespec64(val);
> > > +       ts->tv_sec = cpu_to_le32(t.tv_sec);
> > > +       ts->tv_nsec = cpu_to_le32(t.tv_nsec);
> > 
> > ceph_encode_timespec64() does this with appropriate casts, let's use
> > it.
> 
> Makes sense.
> 
> BTW, this fix would be a new change I guess? (rather than sending an
> updated version of the patch since it has been merged in -testing)?
> 

Better to send a v2 patch. We rebase "testing" all the time and that
means less "churn" overall.

-- 
Jeff Layton <jlayton@redhat.com>

