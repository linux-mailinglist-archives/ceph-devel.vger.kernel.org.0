Return-Path: <ceph-devel+bounces-264-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D612780A23C
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 12:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9201128180D
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 11:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E6ED1B272;
	Fri,  8 Dec 2023 11:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lW29JThh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E79410F7
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 03:31:38 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-58cf894544cso953421eaf.3
        for <ceph-devel@vger.kernel.org>; Fri, 08 Dec 2023 03:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702035098; x=1702639898; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WoJZ8ipzif+3IEpCY3YL1wgPTjPriLXOwAkzk/Y7WzU=;
        b=lW29JThhNkrRO9v21T0hSs2v9pXPJb4Zk6YTd2Ntq505rI1VPHkFTVuOpaFmC5v8hJ
         1BbL58PfmPQcTm5UeivQaisOvMEK5EsNENs8I/fiZqDzGt6xI5l4DUPJWlbTCp1pQTIv
         7lr3CmAKzdfdLv6Wj3Ma+PlvWsWnVBBD+0f2xFM2moSqhPpOQSPHHvZWo+yX55oHi54S
         h/Sary3iezsJomlYrg9Aq+2DcXAF0UjYcg7QXcXvvZGFV1NolGsahlVg59WVqsvUX00Y
         9WxSLYWT7DkQEMTWbXReebuVcoswK1PwPayrPme1tjxq8dLX3k/nz0Bbg2bI3F45ZU2A
         xv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702035098; x=1702639898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WoJZ8ipzif+3IEpCY3YL1wgPTjPriLXOwAkzk/Y7WzU=;
        b=lCcbPpnrSgeXon8FLx/KCQF5TBY5Jn2Dq2zOmugLZBIlmIwKTtZTs/Hcd4JerPD4xk
         Rmq5N11DlDt1UC7/aOZbUlLhyhbuxX26NIAG6iM6L5DaA+jykmybUYancmaiC5ljFNuX
         WILU3mn353C/Mh8VP1nKMEuvPkdaiYRAPZs24qFgwTODHBKBAaQRxNbA2GhFtzA84b+h
         hNhWYCOhinFQjqq+O9Ld8sNb8SAvmDWFeL5H9RY/xPGzuaqY4YUfEeDayZwMWDXVjf6E
         KvAZgoGVnRP3MCpZ3vLBHqNg5Bxpv5imUVrwLtmrM8GS+7hDRBuktxZ8pqaI6NOoSYEb
         Rf3g==
X-Gm-Message-State: AOJu0YxYL9DcAjOuCTQisBNw5J/qkA6dPWsc8xxV4LwSm7lHJLqKilVF
	Nk3OMSHerGdbkRr8i6hpPfBk59XDEamAjk0DS2gUdYIB9ks=
X-Google-Smtp-Source: AGHT+IGvD7wfAtiqWjkmiyfgSbfmfsPXFkYzFo3W/YYRjXoOuA+GK6SfQVmkGBiGkHTLT8LoRX9XfQNrIiPmvN3/0/k=
X-Received: by 2002:a4a:af02:0:b0:590:95e0:bb6c with SMTP id
 w2-20020a4aaf02000000b0059095e0bb6cmr288972oon.1.1702035097744; Fri, 08 Dec
 2023 03:31:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208043305.91249-1-xiubli@redhat.com> <20231208043305.91249-2-xiubli@redhat.com>
In-Reply-To: <20231208043305.91249-2-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 8 Dec 2023 12:31:25 +0100
Message-ID: <CAOi1vP-aL0viMVHjXQr_CA0MyKNQ8FWH1qF4Vh-ntjFrOqYMNA@mail.gmail.com>
Subject: Re: [PATCH 1/2] libceph: fail the sparse-read if there still has data
 in socket
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 5:34=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Once this happens that means there have bugs.
>
> URL: https://tracker.ceph.com/issues/63586
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/osd_client.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 5753036d1957..848ef19055a0 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5912,10 +5912,12 @@ static int osd_sparse_read(struct ceph_connection=
 *con,
>                 fallthrough;
>         case CEPH_SPARSE_READ_DATA:
>                 if (sr->sr_index >=3D count) {
> -                       if (sr->sr_datalen && count)
> +                       if (sr->sr_datalen) {
>                                 pr_warn_ratelimited("sr_datalen %u sr_ind=
ex %d count %u\n",
>                                                     sr->sr_datalen, sr->s=
r_index,
>                                                     count);
> +                               return -EREMOTEIO;
> +                       }
>
>                         sr->sr_state =3D CEPH_SPARSE_READ_HDR;
>                         goto next_op;
> --
> 2.43.0
>

Hi Xiubo,

There is a patch in linux-next, also from you, which is conflicting
with this one: cca19d307d35 ("libceph: check the data length when
sparse read finishes").  Do you want it replaced?

Thanks,

                Ilya

