Return-Path: <ceph-devel+bounces-44-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 447437E1964
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 05:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19B5FB20DC5
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 04:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0672139D;
	Mon,  6 Nov 2023 04:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QLUnXlLU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD33635
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:34:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91278A4
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 20:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699245241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VUosGf/Sxj/80Cqxvan5pECMRe5Vby1+3xEo4BHIyp0=;
	b=QLUnXlLU2CqbsvSNrIpJVOSITfx93vpB69JTkBNld2Qh38ssOIeHfuVw4j8gnsvHHAE3Dy
	qdGXyX5fq56l831jhNhAa5PUvWE+TINPR//QpbTJ26kkPY8WUOs9hccO8vOqDA3bBpSD9m
	sDaQk8On1/qXKkXPVJkDiHP6u2ewKak=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-dXW8QPrhN2StUH0YkOuUNA-1; Sun, 05 Nov 2023 23:34:00 -0500
X-MC-Unique: dXW8QPrhN2StUH0YkOuUNA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9dd489c98e7so153346666b.2
        for <ceph-devel@vger.kernel.org>; Sun, 05 Nov 2023 20:34:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699245239; x=1699850039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUosGf/Sxj/80Cqxvan5pECMRe5Vby1+3xEo4BHIyp0=;
        b=YpNloVRtDYajmwyam6gvuq8EGyslRhdgw2ic5nwKctqwu/FnAfXKWqMSj0ayZ1CwKj
         LeyBlIZjWPvg2i2SLQC5TgEjsYtbJ8b4X29P4h48iJzbzyX2KqX3vZJ3ovPpvxqmskhr
         4x63paHbMU7nTA9FUe6D10+e9+eyedHu+q6nv3l9w/aicbej4ZQo7WlHNR03yNyv77TL
         c8EjzDvnjzrPWsiLQyloMVLml+NAtzdCuT54al8We3RanpBV8eGIj9WptiP4KC8AYjNu
         6jQsOJnqaXDyKg1JKyolCwpJoW+8isNspNeoZDOQgOZshHJ28uiDKhLUn2nac9ZE0tfS
         xNmw==
X-Gm-Message-State: AOJu0Yz/oVsJQ9yMyhVNhR7URy614DEBsgZi+ur1v9yZRuVrjHEi/1BK
	9tPx6V+Foj/XqKVu44hZRMlM+aEaBgkn3LIFJlgzQFSn9ewa/pg1AUdiFCFVe0JqV0T+GhQi/xI
	RQu52G6l4H+jy8FGT8ysEwOSNqER2eizdFlpCdA==
X-Received: by 2002:a17:906:4fd0:b0:9a5:874a:9745 with SMTP id i16-20020a1709064fd000b009a5874a9745mr13663856ejw.26.1699245239219;
        Sun, 05 Nov 2023 20:33:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8+Wp0XD5zwyuL6JxOjZ8vp23P6EMXpgh0TGqYuIqec12pznr6EPPMRHPwJxVcV49d9U3ySfa7Hlw0oqOE8aM=
X-Received: by 2002:a17:906:4fd0:b0:9a5:874a:9745 with SMTP id
 i16-20020a1709064fd000b009a5874a9745mr13663848ejw.26.1699245238965; Sun, 05
 Nov 2023 20:33:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231103064027.316296-1-vshankar@redhat.com> <CACPzV1mkHsWmUy60MxZg0VA-ewm=KW62ODT019jDtSL5EzErNw@mail.gmail.com>
 <184d7c48-42de-e602-e394-3c0b2cbeb0b7@redhat.com> <CACPzV1=ZfG-4AMMhE1_uCNDaC-bRXK8mng7s_zD8GQ0YbUafqg@mail.gmail.com>
 <2b13b358-68be-1a7b-0847-d79270358445@redhat.com>
In-Reply-To: <2b13b358-68be-1a7b-0847-d79270358445@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Mon, 6 Nov 2023 10:03:22 +0530
Message-ID: <CACPzV1nWNsLpdiq6AWJY0UVRYSizO4aP86W7jvQVTK_oHq9w4w@mail.gmail.com>
Subject: Re: [PATCH] ceph: reinitialize mds feature bit even when session in open
To: Xiubo Li <xiubli@redhat.com>
Cc: mchangir@redhat.com, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Done - updated (didn't add v2 to the pathset though).

On Mon, Nov 6, 2023 at 5:55=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/3/23 17:29, Venky Shankar wrote:
> > On Fri, Nov 3, 2023 at 1:23=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wro=
te:
> >>
> >> On 11/3/23 14:43, Venky Shankar wrote:
> >>> On Fri, Nov 3, 2023 at 12:10=E2=80=AFPM Venky Shankar <vshankar@redha=
t.com> wrote:
> >>>> Following along the same lines as per the user-space fix. Right
> >>>> now this isn't really an issue with the ceph kernel driver because
> >>>> of the feature bit laginess, however, that can change over time
> >>>> (when the new snaprealm info type is ported to the kernel driver)
> >>>> and depending on the MDS version that's being upgraded can cause
> >>>> message decoding issues - so, fix that early on.
> >>>>
> >>>> URL: Fixes: http://tracker.ceph.com/issues/63188
> >>>> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> >>>> ---
> >>>>    fs/ceph/mds_client.c | 1 +
> >>>>    1 file changed, 1 insertion(+)
> >>>>
> >>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >>>> index a7bffb030036..48d75e17115c 100644
> >>>> --- a/fs/ceph/mds_client.c
> >>>> +++ b/fs/ceph/mds_client.c
> >>>> @@ -4192,6 +4192,7 @@ static void handle_session(struct ceph_mds_ses=
sion *session,
> >>>>                   if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN)=
 {
> >>>>                           pr_notice_client(cl, "mds%d is already ope=
ned\n",
> >>>>                                            session->s_mds);
> >>>> +                       session->s_features =3D features;
> >>> Xiubo, the metrics stuff isn't done here (as it's done in the else
> >>> case). That's probably required I guess??
> >> That should be okay, but it harmless to do it here.
> >>
> >> So let's just fix it by:
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index 41be58baaa57..de3c6b6cbd07 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -4263,17 +4263,16 @@ static void handle_session(struct
> >> ceph_mds_session *session,
> >>                           pr_info_client(cl, "mds%d reconnect success\=
n",
> >>                                          session->s_mds);
> >>
> >> -               if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN) {
> >> +               if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN)
> >>                           pr_notice_client(cl, "mds%d is already opene=
d\n",
> >>                                            session->s_mds);
> >> -               } else {
> >> +               else
> >>                           session->s_state =3D CEPH_MDS_SESSION_OPEN;
> >> -                       session->s_features =3D features;
> >> -                       renewed_caps(mdsc, session, 0);
> >> -                       if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
> >> -                                    &session->s_features))
> >> - metric_schedule_delayed(&mdsc->metric);
> >> -               }
> >> +               session->s_features =3D features;
> >> +               renewed_caps(mdsc, session, 0);
> > Call to renewed_caps() isn't really required if the session state is
> > already open, isn't it? Doesn't harm to call it I guess, but...
>
> Yeah.
>
> Then let's just do:
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 41be58baaa57..45d0f445cdef 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4263,12 +4263,12 @@ static void handle_session(struct
> ceph_mds_session *session,
>                          pr_info_client(cl, "mds%d reconnect success\n",
>                                         session->s_mds);
>
> +               session->s_features =3D features;
>                  if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN) {
>                          pr_notice_client(cl, "mds%d is already opened\n"=
,
>                                           session->s_mds);
>                  } else {
>                          session->s_state =3D CEPH_MDS_SESSION_OPEN;
> -                       session->s_features =3D features;
>                          renewed_caps(mdsc, session, 0);
>                          if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
>                                       &session->s_features))
>
> Thanks
>
> - Xiubo
>
>
> >> +               if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
> >> +                            &session->s_features))
> >> + metric_schedule_delayed(&mdsc->metric);
> >>
> >>                   /*
> >>                    * The connection maybe broken and the session in cl=
ient
> >>
> >> Thanks
> >>
> >> - Xiubo
> >>
> >>
> >>>>                   } else {
> >>>>                           session->s_state =3D CEPH_MDS_SESSION_OPEN=
;
> >>>>                           session->s_features =3D features;
> >>>> --
> >>>> 2.39.3
> >>>>
> >
>


--=20
Cheers,
Venky


