Return-Path: <ceph-devel+bounces-32-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE197DFFFE
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 10:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7206F281DE4
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 09:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29907111BF;
	Fri,  3 Nov 2023 09:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mj06hn5K"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDE2CA51
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:29:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B324D42
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 02:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699003785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0/0vU/iHzYTi6s4HQTZiVFFEC3P+yEn1obudUnp/urY=;
	b=Mj06hn5KyO233NkNz0/EE68hcNJJf19mYh6+YlJnFyiPrtbaifp33D/55d7opJlzvNzguY
	7Vj1+yA98f87VkM9PInVC2P6rEI0UnPhKZsjchvz3fTKJmVqrv8wS4TW8aAWvWrQL9JFcM
	T2kp83tRkKzwwk4ZYh85YCfFGCKg2PM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-k0mEt17oPNe2gS4jg3DCWA-1; Fri, 03 Nov 2023 05:29:43 -0400
X-MC-Unique: k0mEt17oPNe2gS4jg3DCWA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9d25d0788b8so124738366b.1
        for <ceph-devel@vger.kernel.org>; Fri, 03 Nov 2023 02:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699003783; x=1699608583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/0vU/iHzYTi6s4HQTZiVFFEC3P+yEn1obudUnp/urY=;
        b=gmbpHpx1rTBa2RAfGB35TSwYC6q4Y5JfIOy2oEPFfIJg4UeqgndsiZG2nVuVdObelQ
         OxmgNjhflCUXy1gWlcFxiNa6WGd2msrrEZRTeMqd3q8YUd9XojtuexmR7LqaulNMXSMk
         vkusNZLp8qhjCAWNIkjd0B//1ySedl9bb2nWwrWmEDmhZmEyJPeBtIOWup+1F9qpQzso
         sWvRldaXWR4hwIxprRPaq36WyvukOxb97UeU9iKmcHhUGY/E36XSxgPsFcgODczT6fpC
         UvbT6ZhkP7MFJGjaXwB3ct2MvJW79KsLyv/e6o4RjpJosYOGnMz3QchuHcpNcj31Snia
         M1Mw==
X-Gm-Message-State: AOJu0YzaLxPViDbEWtLAAIjvRnbBc0FM0DWtpnPKEPCeZKvE+ImA+YLz
	MS25ZSALAL/9+pVrtVV1qr8ViKckHmHuLjBBzGIstjcMJmKhLoRIVo/ssTGfLN74ImfoP7dkrfi
	tIFi8FuQcqnYYhHyCbLmHp62M8noOq1kcVbB7Pg==
X-Received: by 2002:a17:907:318c:b0:9d3:8d1e:ce8 with SMTP id xe12-20020a170907318c00b009d38d1e0ce8mr7156230ejb.20.1699003782760;
        Fri, 03 Nov 2023 02:29:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCpPOo/2w8re4r/ajIANVqN+/wubnx+xS1Vmab8i/q6VgYW4fCoNNP1sKdBacBSl/H+ysZLwx7K0ThAo94Ijs=
X-Received: by 2002:a17:907:318c:b0:9d3:8d1e:ce8 with SMTP id
 xe12-20020a170907318c00b009d38d1e0ce8mr7156218ejb.20.1699003782368; Fri, 03
 Nov 2023 02:29:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231103064027.316296-1-vshankar@redhat.com> <CACPzV1mkHsWmUy60MxZg0VA-ewm=KW62ODT019jDtSL5EzErNw@mail.gmail.com>
 <184d7c48-42de-e602-e394-3c0b2cbeb0b7@redhat.com>
In-Reply-To: <184d7c48-42de-e602-e394-3c0b2cbeb0b7@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Fri, 3 Nov 2023 14:59:05 +0530
Message-ID: <CACPzV1=ZfG-4AMMhE1_uCNDaC-bRXK8mng7s_zD8GQ0YbUafqg@mail.gmail.com>
Subject: Re: [PATCH] ceph: reinitialize mds feature bit even when session in open
To: Xiubo Li <xiubli@redhat.com>
Cc: mchangir@redhat.com, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 1:23=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/3/23 14:43, Venky Shankar wrote:
> > On Fri, Nov 3, 2023 at 12:10=E2=80=AFPM Venky Shankar <vshankar@redhat.=
com> wrote:
> >> Following along the same lines as per the user-space fix. Right
> >> now this isn't really an issue with the ceph kernel driver because
> >> of the feature bit laginess, however, that can change over time
> >> (when the new snaprealm info type is ported to the kernel driver)
> >> and depending on the MDS version that's being upgraded can cause
> >> message decoding issues - so, fix that early on.
> >>
> >> URL: Fixes: http://tracker.ceph.com/issues/63188
> >> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> >> ---
> >>   fs/ceph/mds_client.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index a7bffb030036..48d75e17115c 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -4192,6 +4192,7 @@ static void handle_session(struct ceph_mds_sessi=
on *session,
> >>                  if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN) {
> >>                          pr_notice_client(cl, "mds%d is already opened=
\n",
> >>                                           session->s_mds);
> >> +                       session->s_features =3D features;
> > Xiubo, the metrics stuff isn't done here (as it's done in the else
> > case). That's probably required I guess??
>
> That should be okay, but it harmless to do it here.
>
> So let's just fix it by:
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 41be58baaa57..de3c6b6cbd07 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4263,17 +4263,16 @@ static void handle_session(struct
> ceph_mds_session *session,
>                          pr_info_client(cl, "mds%d reconnect success\n",
>                                         session->s_mds);
>
> -               if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN) {
> +               if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN)
>                          pr_notice_client(cl, "mds%d is already opened\n"=
,
>                                           session->s_mds);
> -               } else {
> +               else
>                          session->s_state =3D CEPH_MDS_SESSION_OPEN;
> -                       session->s_features =3D features;
> -                       renewed_caps(mdsc, session, 0);
> -                       if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
> -                                    &session->s_features))
> - metric_schedule_delayed(&mdsc->metric);
> -               }
> +               session->s_features =3D features;
> +               renewed_caps(mdsc, session, 0);

Call to renewed_caps() isn't really required if the session state is
already open, isn't it? Doesn't harm to call it I guess, but...

> +               if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
> +                            &session->s_features))
> + metric_schedule_delayed(&mdsc->metric);
>
>                  /*
>                   * The connection maybe broken and the session in client
>
> Thanks
>
> - Xiubo
>
>
> >
> >>                  } else {
> >>                          session->s_state =3D CEPH_MDS_SESSION_OPEN;
> >>                          session->s_features =3D features;
> >> --
> >> 2.39.3
> >>
> >
>


--=20
Cheers,
Venky


