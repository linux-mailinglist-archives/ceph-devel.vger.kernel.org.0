Return-Path: <ceph-devel+bounces-276-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE0280F2BA
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Dec 2023 17:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AB2E1C20DF6
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Dec 2023 16:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A6A77F36;
	Tue, 12 Dec 2023 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mICWJZT3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A28BA8
	for <ceph-devel@vger.kernel.org>; Tue, 12 Dec 2023 08:31:54 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-20307e91258so360842fac.0
        for <ceph-devel@vger.kernel.org>; Tue, 12 Dec 2023 08:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702398713; x=1703003513; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ps5ol27veVBm90USE7ImW/oki5bYUDFMVr3xXLbhDrU=;
        b=mICWJZT3gnz8VY8onO1PJ960u+VARBwUPAd4W3qOlgVYG/q3TrdHZA8MXMNPybT3nk
         pxud7vdIVLODwhiSlMSbS8nbQZ0QEXqCSfBa21P6Ek4tgOO1SOZuoMGsco91vSySggij
         yhB6QtRoVlKUtJaqQRliyBXT7DT2er+VAlsbyqWu/WJTRvKLOFelDmBh5JpGZLpwoVZC
         cEnkdDM9jymoRaNENeLH5k8UDLjfxP4syafyguVJI1EaspmGDmHtiZ4T5hZ0TFYhvoT7
         s8SI6nrnVLGDYzgXZToBWANKeiZnPorU4AJoogNNnxVnLm4MoGYlBg6hk07AXeKVFdib
         at/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702398713; x=1703003513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ps5ol27veVBm90USE7ImW/oki5bYUDFMVr3xXLbhDrU=;
        b=n/8sdGfOJT4FQ4GxmFc386U7UmRmzF3XPV/oKqIPu1kEz278HDTVDm4/BjrXDuIfYv
         yjOmNa20BuZs/LV0ZrntLiK7iX2Mxy+Kwl9lF9b0hHTA5/M8ykzb/sl8JrojLUFWcNzm
         jRWDtffuCbdSJfGqKJZX8XTwoEcNfv+8xV2/yVnDCaBaI6P6yw5DfOLTPLnzLUuGAooW
         jZU90pREbGDJhIAdKyWNzWfhzJJVfB/k0xZ8Io0MzlEk+3UHAm72nDH/luQdmQlZvkZx
         TgdTxkCdqL9ZMpamwFPy3vH9z62mzeczxumehADdNYEKR2+wkkr8uqQh3qwA+Y1MHL2A
         FXNQ==
X-Gm-Message-State: AOJu0YytwU17KaaE8/Rw1ySwDtx1xC+pZobXjoNINefZvF/F2y/Tous5
	i3Rh0jzTVOyHY9Dk9BSLoutr3RFGd4SjkkXR1eY=
X-Google-Smtp-Source: AGHT+IFZrnBhlD2cLptbatQ7sikKSQaR6j0Vp7Evr22jVZx7y93rllEAIU87tQJdixtxSYGrKZxn051sPNFOo8ph7Ss=
X-Received: by 2002:a05:6871:14a:b0:1fb:1c29:167 with SMTP id
 z10-20020a056871014a00b001fb1c290167mr5950330oab.3.1702398713161; Tue, 12 Dec
 2023 08:31:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208160601.124892-1-xiubli@redhat.com> <20231208160601.124892-3-xiubli@redhat.com>
In-Reply-To: <20231208160601.124892-3-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 12 Dec 2023 17:31:41 +0100
Message-ID: <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libceph: just wait for more data to be available
 on the socket
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 5:08=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The messages from ceph maybe split into multiple socket packages
> and we just need to wait for all the data to be availiable on the
> sokcet.
>
> This will add a new _FINISH state for the sparse-read to mark the
> current sparse-read succeeded. Else it will treat it as a new
> sparse-read when the socket receives the last piece of the osd
> request reply message, and the cancel_request() later will help
> init the sparse-read context.
>
> URL: https://tracker.ceph.com/issues/63586
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/osd_client.h | 1 +
>  net/ceph/osd_client.c           | 6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
> index 493de3496cd3..00d98e13100f 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
>         CEPH_SPARSE_READ_DATA_LEN,
>         CEPH_SPARSE_READ_DATA_PRE,
>         CEPH_SPARSE_READ_DATA,
> +       CEPH_SPARSE_READ_FINISH,
>  };
>
>  /*
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 848ef19055a0..f1705b4f19eb 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_connec=
tion *con,
>                         advance_cursor(cursor, sr->sr_req_len - end, fals=
e);
>         }
>
> -       ceph_init_sparse_read(sr);
> -
>         /* find next op in this request (if any) */
>         while (++o->o_sparse_op_idx < req->r_num_ops) {
>                 op =3D &req->r_ops[o->o_sparse_op_idx];
> @@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connection *=
con,
>                                 return -EREMOTEIO;
>                         }
>
> -                       sr->sr_state =3D CEPH_SPARSE_READ_HDR;
> +                       sr->sr_state =3D CEPH_SPARSE_READ_FINISH;
>                         goto next_op;

Hi Xiubo,

This code appears to be set up to handle multiple (sparse-read) ops in
a single OSD request.  Wouldn't this break that case?

I think the bug is in read_sparse_msg_data().  It shouldn't be calling
con->ops->sparse_read() after the message has progressed to the footer.
osd_sparse_read() is most likely fine as is.

Notice how read_partial_msg_data() and read_partial_msg_data_bounce()
behave: if called at that point (i.e. after the data section has been
processed, meaning that cursor->total_resid =3D=3D 0), they do nothing.
read_sparse_msg_data() should have a similar condition and basically
no-op itself.

While at it, let's rename it to read_partial_sparse_msg_data() to
emphasize the "partial"/no-op semantics that are required there.

Thanks,

                Ilya

