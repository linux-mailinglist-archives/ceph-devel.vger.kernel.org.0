Return-Path: <ceph-devel+bounces-954-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6CB87061E
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 16:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76A9428A7C8
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 15:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61703482D3;
	Mon,  4 Mar 2024 15:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPaj/sKd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8709D47A48;
	Mon,  4 Mar 2024 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709567170; cv=none; b=l01dxxXHpYETZpx12iksm3n/SyLbWLR5nOyzX/fxfpbGWo6G8SRfaWp+YWcrhx+0WpnTcQf56nwZJfIDJC84/xNhgVcu8+S1ZiLoJOzpBi6+brhLD8ApuPdJyS9dqavZ+8Cuob1qcsgOAKWCUlhw+ilUh0TzF9nIZJNFOBzrbpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709567170; c=relaxed/simple;
	bh=da9fZ/trmtyI+up0UunVVXCzSbAPhu9jz8DQSkFoLC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ukZIffVuhPrSLRbVFLmPkF0zff3nBGtAE6Y6d9c+zhQ1So/W2Jp0LXl1QRvpXEhxWenTqPz8opSrdknK1/Tw9hQO26PcjQUWkJw+qeyJgT+IpN22vbIGmIMvp4qEcygyD9OlAUiFP84yAVC1nPijQDwq/3NjmEGSdP8r8DXauOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LPaj/sKd; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c19e18470aso3009254b6e.1;
        Mon, 04 Mar 2024 07:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709567167; x=1710171967; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OraLzwlepOI/cLYuOQODKU0SCQhpV+rF7zSeP6PovF4=;
        b=LPaj/sKdPE4/gKHIem9JT9Zkd2Fb2BEKEzsgadq7/mWY0vPHEepELhxtbl8g6mklYV
         JuqeyeTAVd8mxhCkZD0ZoRiFm8w8kruvtg+GpWxen1IlTOx4ZcnoI6IlrtadiFP94i/P
         0hqEBOBQwHA6f/S5oCfUeWw6137cevDruUNxhAvAhibYYTOPea8ecNEYvk4j6Y655XP+
         sVnnzmTquf5UO6vS51NLVLTpfXz0yVqec6NvRJUxBy5aFleDuGD2VFGyGEGbqApQoCtP
         BWYeuzNoLrU1NeurtXNPP8vKBlHOlhAGLvBG6SruYJkvr/KrG/MtF09+vkVXS9gL42nP
         Mi8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709567167; x=1710171967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OraLzwlepOI/cLYuOQODKU0SCQhpV+rF7zSeP6PovF4=;
        b=u5r5tZfnCZjK6+lPZHXk9oy1O24SJZFEO0SyidnP/BNBPIFvcH/MnSZ4SfmzvgqE/9
         m+NmuUF38pohnFDvyRJyGFNJvdD+kF1IlcJ+FLY6XUFKfpTW4asvyeObathTi7VIk6Gm
         2GCXdM675QQQT12nKhpOKYQoo5zOEQFO33PNKqbIeRgNFEHBp4YSgcQ0k9KL0GFcV7PF
         AXfLCYWyDi7uk7RoGy4MzAl02ni0Acm/wjwaLFj6n1nBnF0Tbr34F8nLW6+dkz5G5X46
         C+Y06Gh7DKDXauSVtE7E89InITPTLaEqX/Wqw0SLpevYR0pAPMG0Xj4+5v1bFJg0H2la
         45LQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcn2EEu7XCGzvyV94bzUgwG6+09JpcyOd8giFwA1Ru76z9G+cyiazT5mZsJPSmczRNZnCNWWGATdKbFi1Z9lOAVC+C6sse
X-Gm-Message-State: AOJu0Yyatzp56GYaNHQoocc3h5CZoj8AVd+oOPOgXMMVSmTLCEA/y58p
	WVzba6zGoyFswXpcvNCERP69AnhM4lxNmZjVmi8ZPJKxq/gkx0NqbWaQ1neV+MrikV0gQTc+HHm
	ioL2RogEqGud669skpidJbZG0W8uZmtRQVsM=
X-Google-Smtp-Source: AGHT+IF7kJ4GjmlDetevTTIbe1hm4J5bEFODRqkard9l2g+MS0VoomPQ48TFtMMAJFu/WSstn0WUOaTrzP7NzhVGU14=
X-Received: by 2002:aca:1a1a:0:b0:3c1:c069:3316 with SMTP id
 a26-20020aca1a1a000000b003c1c0693316mr1674617oia.21.1709567167560; Mon, 04
 Mar 2024 07:46:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229041950.738878-1-xiubli@redhat.com> <CAOi1vP-hp7jmECXP4WNDT801qmBBZJjnUm0ic61Pw-JgipOyNw@mail.gmail.com>
 <10abc117-a0e8-47ab-b9e2-05424c358c4e@redhat.com> <CAOi1vP_=qP0EQTEAaJ2teA8PE1cBXDO0bc_KoRBYxf9jwA4iwA@mail.gmail.com>
 <f54b8fb3-4343-4802-a495-51c5feed52b4@redhat.com>
In-Reply-To: <f54b8fb3-4343-4802-a495-51c5feed52b4@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 4 Mar 2024 16:45:55 +0100
Message-ID: <CAOi1vP-AHqoMM5FL2nDTxuXj6uJsNZb5SbxzUZBL97==UhHKNg@mail.gmail.com>
Subject: Re: [PATCH] libceph: init the cursor when preparing the sparse read
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, stable@vger.kernel.org, 
	Luis Henriques <lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 3:00=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 3/4/24 19:02, Ilya Dryomov wrote:
>
> On Mon, Mar 4, 2024 at 2:02=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote=
:
>
> On 3/2/24 00:16, Ilya Dryomov wrote:
>
> On Thu, Feb 29, 2024 at 5:22=E2=80=AFAM <xiubli@redhat.com> wrote:
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
>   net/ceph/messenger_v2.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index a0ca5414b333..7ae0f80100f4 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_con=
nection *con)
>   static int prepare_sparse_read_data(struct ceph_connection *con)
>   {
>          struct ceph_msg *msg =3D con->in_msg;
> +       u64 len =3D con->in_msg->sparse_read_total ? : data_len(con->in_m=
sg);
>
> Hi Xiubo,
>
> Why is sparse_read_total being tested here?  Isn't this function
> supposed to be called only for sparse reads, after the state is set to
> IN_S_PREPARE_SPARSE_DATA based on a similar test:
>
>      if (msg->sparse_read_total)
>              con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA;
>      else
>              con->v2.in_state =3D IN_S_PREPARE_READ_DATA;
>
> Then the patch could be simplified and just be:
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index a0ca5414b333..ab3ab130a911 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -2034,6 +2034,9 @@ static int prepare_sparse_read_data(struct
> ceph_connection *con)
>          if (!con_secure(con))
>                  con->in_data_crc =3D -1;
>
> +       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
> + con->in_msg->sparse_read_total);
> +
>          reset_in_kvecs(con);
>          con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA_CONT;
>          con->v2.data_len_remain =3D data_len(msg);
>
> Else where should we do the test like this ?
>
> Hi Xiubo,
>
> I suspect you copied this test from prepare_message_data() in msgr1,
> where that function is called unconditionally for all reads.  In msgr2,
> prepare_sparse_read_data() is called conditionally, so the test just
> seems bogus.
>
> That said, CephFS is the only user of sparse read code, so you should
> know better at this point ;)
>
> As we know the 'sparse_read_total' it's a dedicated member and will be se=
t only in sparse-read case.
>
> In msgr1 for all the read cases they will call "prepare_message_data()", =
so I just did this check in "prepare_message_data()".

Right.

>
> While for msgr2 it's a little different from msg1 and it won't call 'prep=
are_read_data()' for all the reads, and for sparse-read it has its own dedi=
cated helper, which is "prepare_sparse_read_data()".

Right.

> So I just did this check in 'prepare_sparse_read_data()' instead.

This where I'm getting lost.  Why do a "is this a sparse read" check in
a helper that is dedicated to sparse reads and isn't called for anything
else?

> For "prepare_read_data()" it doesn't make any sense to check "sparse_read=
_total".

Right, so why doesn't the same go for prepare_sparse_read_data()?

Thanks,

                Ilya

