Return-Path: <ceph-devel+bounces-30-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F15057DFF3D
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 07:44:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BC711C21005
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 06:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF8C187C;
	Fri,  3 Nov 2023 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X+vRjf0h"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1D77E
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 06:44:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA254D7
	for <ceph-devel@vger.kernel.org>; Thu,  2 Nov 2023 23:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698993874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BuMguP2FQopmnTL7KP+J4tRpz76r5wkN4Bgdc+rYRSQ=;
	b=X+vRjf0hqbfjVeF3PSZyUQkwpSxCbxNiB9IKzF4fNG+YstAEjF74SX4eoqdFDTpoAFkaY4
	toBcke6OAuwjOtwBjxJsy1Dhbb1dmyWsWMTi2kLeegsf0Z1xPx6zFiPf90bX23hE9FIlW7
	C1DGzhR01CubNiGSwrYRxkBp+KlI7k4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-ipaf4PxTNE6SSNYAfKhmTg-1; Fri, 03 Nov 2023 02:44:32 -0400
X-MC-Unique: ipaf4PxTNE6SSNYAfKhmTg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5079630993dso1550782e87.1
        for <ceph-devel@vger.kernel.org>; Thu, 02 Nov 2023 23:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698993871; x=1699598671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BuMguP2FQopmnTL7KP+J4tRpz76r5wkN4Bgdc+rYRSQ=;
        b=JjHI3atFzroPgMgMBKn2MwLldM0FV5TbIXtXBVC20EW8IOu3T62Qsv2epxPBp/e5iT
         79paxJi5PHiGfQh9IMv0O4I0b0GAu9GZ+iDH/qZPV6eTNaAUUQrCMc2WsYZ0cBNslXlP
         GsD7BCLKPIDnvVHJGQl51wew9Fk9hi6qtFE6feDowC7Zzxi0Woi9llxDSIw9rrEkmWAh
         1rWjjBfGs7BLtRWgNGIJXioJaM1SkSw1RM42caeL/IozoddDJzXiqAiuiipvWDEPbsck
         vhARfp6Qy7hDF+k9Z5+kgxZVE35/EVq9rT5YdinNsuoXpw1OpbZ9wkn8TdhrSrKm0iXT
         cC4Q==
X-Gm-Message-State: AOJu0YxP8rrCIM+o1mWyLVQ62EWAeqlIrUcr8QuuturbPVXVgrOstG9B
	y6pOzIVpXu4a9UHgwBpxwUmOXzyTRWtQz/1zXEpVfO9rZfb0JGRISqwnrMY/rU5ERf2FSyPV2G5
	ff2JJkLdA49MiOC6NV0rjCj9wXe1BTS87YyExmA==
X-Received: by 2002:a05:6512:4850:b0:507:97ca:ec60 with SMTP id ep16-20020a056512485000b0050797caec60mr14961211lfb.3.1698993871171;
        Thu, 02 Nov 2023 23:44:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOBpdLiMa9UqoB2HvGC0giV6c7lRfcSYDIT+nTF8vUINOKJdwgV4FMoln7Tjbn3Wp4XNJbaY/ycjbOIPhwKa4=
X-Received: by 2002:a05:6512:4850:b0:507:97ca:ec60 with SMTP id
 ep16-20020a056512485000b0050797caec60mr14961203lfb.3.1698993870846; Thu, 02
 Nov 2023 23:44:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231103064027.316296-1-vshankar@redhat.com>
In-Reply-To: <20231103064027.316296-1-vshankar@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Fri, 3 Nov 2023 12:13:54 +0530
Message-ID: <CACPzV1mkHsWmUy60MxZg0VA-ewm=KW62ODT019jDtSL5EzErNw@mail.gmail.com>
Subject: Re: [PATCH] ceph: reinitialize mds feature bit even when session in open
To: xiubli@redhat.com
Cc: mchangir@redhat.com, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 12:10=E2=80=AFPM Venky Shankar <vshankar@redhat.com>=
 wrote:
>
> Following along the same lines as per the user-space fix. Right
> now this isn't really an issue with the ceph kernel driver because
> of the feature bit laginess, however, that can change over time
> (when the new snaprealm info type is ported to the kernel driver)
> and depending on the MDS version that's being upgraded can cause
> message decoding issues - so, fix that early on.
>
> URL: Fixes: http://tracker.ceph.com/issues/63188
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/mds_client.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a7bffb030036..48d75e17115c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4192,6 +4192,7 @@ static void handle_session(struct ceph_mds_session =
*session,
>                 if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN) {
>                         pr_notice_client(cl, "mds%d is already opened\n",
>                                          session->s_mds);
> +                       session->s_features =3D features;

Xiubo, the metrics stuff isn't done here (as it's done in the else
case). That's probably required I guess??

>                 } else {
>                         session->s_state =3D CEPH_MDS_SESSION_OPEN;
>                         session->s_features =3D features;
> --
> 2.39.3
>


--=20
Cheers,
Venky


