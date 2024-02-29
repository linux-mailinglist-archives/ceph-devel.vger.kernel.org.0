Return-Path: <ceph-devel+bounces-939-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CAC786C73D
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Feb 2024 11:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02D611F231C1
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Feb 2024 10:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1070B79DDF;
	Thu, 29 Feb 2024 10:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mdlrkwjx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534BE79DCF;
	Thu, 29 Feb 2024 10:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203712; cv=none; b=p2rMt1BU12xnjTP0d4LLwpACWLJR+YGD+1RtjDkcykUVM380x6fUcQbfdS482LEwZnV/NZQEzQohyd7OAS7qMBenVjzgAfHLbaIFVOV6lEo07t99le/YM5bcRAhxqAX5oE+6MHAmx5XNboI3KrqCuazt9y9biOU0anUwQjerJwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203712; c=relaxed/simple;
	bh=b6a/bwHTRJFN6ecS46XR5ZRCXemQ7CwQoG3XkXz9OJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZIB/E0ivqjDJgApKHRslwY/4uXm9XxGpUDo6LRXROYqtpZP6CAl4sHLAzzahKFDcvz96TstprLowbHGTDuB6Kl5Sb4Su1NR5lcpgCjsXGJZPf3jZxnWMrgcdBoiYvDDP4hv7XY3mfA3ziFlbHDs7F8xbD24GkfuikOQrpbW41Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mdlrkwjx; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5a04dd6721dso202239eaf.0;
        Thu, 29 Feb 2024 02:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709203710; x=1709808510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NnCCO7nodxLFeiorzdBxG1atN61rxSRJVQMtzMIAomA=;
        b=Mdlrkwjx+ppNlpDi9pGzuVPD5wok1kW9Xm7EIGnSL5bBsWD5DMLaTx/wKf8oFnztrS
         FKmmrPZhyYOh43AFWjjTDvAFl7GPQw1U5XzclSZcRxgMpbWaDxqaIoF9XzCgb4+D4HvA
         DrA9Gya3g7VOm9LTsaMPY4C9oDImvtt8qyFYznbYsUyFIuH/2LPbC4/v1NtaF5AJmXlR
         +A/KHrNpCgZVV1QyI9SR7t2k13wxg7hLn0yGcjVEoTHWJ2fHSPgf2DL7PYQxeIXUntOU
         OZnHvXgnLKKZOEF9f5s1z16mX9fmLMbmU06BYDHehYPsJve21Vk6PqLWnFbTQD7/fdQ8
         aoCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709203710; x=1709808510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NnCCO7nodxLFeiorzdBxG1atN61rxSRJVQMtzMIAomA=;
        b=rmhpfpHKUUTXEIflSuOPl8SK3J1yL8weR1XeYoA46Cw49DWY1lQEfH5uJgk19BlZng
         Na6j4y4BFzFZxmUfWNWzDmcuAl24YauR6uTqRNvFBw8TIqzZqKXyyQXjqKlHZH2waz5N
         uImkLNuGtARMoHT/4RvjJqhepvg5nZdscJE3rrP+Jv1SXY9iNOgA2nxAWCNN0ggBfgfx
         fStIoCCuPWBBKdIDSJ7FSMZFxvsmcHr92wR87XSwRMBP28jHBmmeRBOGKvnqnUkmqFnA
         b4KuTBNK+JwY4afUywk+Nj08ksV59OWpCRmggG7iqRsEZJX6015BpTpZxtu4I9vFHDTr
         K8GA==
X-Forwarded-Encrypted: i=1; AJvYcCU5Xi7VFDYI9dt6uneAb0C+rAMPclI0CpCLGl/IgbbqVp2TsS5jqlhGAtwFg4Uezpk/ypwdWCely1fikU6NDOH0hqbensGd
X-Gm-Message-State: AOJu0YzH8urYY/3sTWOWPqYTbhIWkuHn/XAcHSMRy45Ven/RXWCI/RGx
	gFPI7YIbkPJ5Lf4KJNGTxDm9D1fLOXSB6hxIOtWl4Z+BKAoZlgBtrUsw6t4dx8qaVPxaH0nfcFa
	FhCQNJQQUccxYa7jx1qCj1PFLyvQ=
X-Google-Smtp-Source: AGHT+IFz18nU38OzSmBaEvQANGtpy7VF58o0lr/KLcVKXCo7GX1xRj8n5lBF2WnMt0eXlyNJ+GUDp96PZKqo+UGfU64=
X-Received: by 2002:a4a:d2c7:0:b0:5a0:4598:1f81 with SMTP id
 j7-20020a4ad2c7000000b005a045981f81mr1636677oos.4.1709203709783; Thu, 29 Feb
 2024 02:48:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229041950.738878-1-xiubli@redhat.com>
In-Reply-To: <20240229041950.738878-1-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 29 Feb 2024 11:48:17 +0100
Message-ID: <CAOi1vP-n34TCcKoLLKe3yXRqS93qT4nc5pkM8Byo-D4zH-KZWA@mail.gmail.com>
Subject: Re: [PATCH] libceph: init the cursor when preparing the sparse read
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, stable@vger.kernel.org, 
	Luis Henriques <lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 5:22=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The osd code has remove cursor initilizing code and this will make
> the sparse read state into a infinite loop. We should initialize
> the cursor just before each sparse-read in messnger v2.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/64607
> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on=
 the socket")
> Reported-by: Luis Henriques <lhenriques@suse.de>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/messenger_v2.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index a0ca5414b333..7ae0f80100f4 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_con=
nection *con)
>  static int prepare_sparse_read_data(struct ceph_connection *con)
>  {
>         struct ceph_msg *msg =3D con->in_msg;
> +       u64 len =3D con->in_msg->sparse_read_total ? : data_len(con->in_m=
sg);
>
>         dout("%s: starting sparse read\n", __func__);
>
> @@ -2034,6 +2035,8 @@ static int prepare_sparse_read_data(struct ceph_con=
nection *con)
>         if (!con_secure(con))
>                 con->in_data_crc =3D -1;
>
> +       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, len);
> +
>         reset_in_kvecs(con);
>         con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA_CONT;
>         con->v2.data_len_remain =3D data_len(msg);
> --
> 2.43.0
>

Hi Xiubo,

How did this get missed?  Was generic/580 not paired with msgr2 in crc
mode or are we not running generic/580 at all?

Multiple runs have happened since the patch was staged so if the matrix
is set up correctly ms_mode=3Dcrc should have been in effect for xfstests
at least a couple of times.

Thanks,

                Ilya

