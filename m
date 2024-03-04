Return-Path: <ceph-devel+bounces-951-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7624D86FFB8
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 12:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CD2E285848
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 11:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52343381D5;
	Mon,  4 Mar 2024 11:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Frv8mNhq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789671B814;
	Mon,  4 Mar 2024 11:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709550139; cv=none; b=H6aRONdXkwt9dsEfgZC/l4Ejl7cHGNxdH4igTIbXyip4m0U53v095TVt7DKYa62N4nlzO3IN8/jYSRO2GIfZ4ZL+jXXwRjkqp5eBXeqAk7FfGBtpJ0JawbCxLPlHdwzgp/yCHukUIAhwJJKzrmpmrwcAk7DV1SSB4joi8EJdL4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709550139; c=relaxed/simple;
	bh=Oo/rFWJcixpRf2/WwehXFRWrzD2gkyR2NzR9XmWmaNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sMz4vudf4x38vP6d1Q/MovpjUPCEYZCs2ZUWlQpbz1rnsFOpz5IKkO8tA20BuJJDMNSIDI8QlHl4cTFi4OyD+rAjnQHa0RBW/Hjiz7bBLDICcIl7WOEupguIc56DBRCMJHxnRyksYXEldQxOMB2ieRBTXX82Ka5z0LucrkCO0Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Frv8mNhq; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-59fc2d22cfaso1421437eaf.3;
        Mon, 04 Mar 2024 03:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709550136; x=1710154936; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEQEcIRITkDJdwdBYFSb2DlZavvyvEzESUuUHNPqnXM=;
        b=Frv8mNhqKgu4eklBeizrWpfyxbVWxp66uBDGY00IOggCp/W8wtp7GosU8QFPBSG9Ko
         qJDh9hYnsXktzvsAbegVBTqUl95T3oFqZRWE99q9R7ZtYOU9yyVi2houN76rWzMTMUQp
         l+vrtSkG0Pg2gSSUvlZViZQAvq0mOmvRVs1QcIubBk1mlOgYzIuhvIcVYrYaue9kXL6s
         fKqbv0UFTuZjnnAppAsA2oEw5JmXDQo+1fFRwcZB/4jebtFhCkMOCzfMi/FQje36GLPR
         l4rPu/9knVe9xPEMWiZxKT/azF5fuT8lG3MvXqV7j1Avo6Htd7L9agJs8+YHfcRWIb1a
         AqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709550136; x=1710154936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEQEcIRITkDJdwdBYFSb2DlZavvyvEzESUuUHNPqnXM=;
        b=ptyQs7RIygnMw/JCedx8ZX4/XvowtRWWb7otPwX2VdbHTtk2HB1jP73eLMjJiY3MwD
         8nx0ZC79JOvN/s1wsk/6/YteGOLgFmhdmkMFa93YTDzL1scuIseMILxeo0Cxm+aj+Nrs
         EtVlTVm6HwvSi2xx93lDN8CYZQpYc1qw+TUDECH0K4vWM0SWeV66zus5Pcdz9sXDjvmJ
         ljmuXL2WzasuyQLcFe1EzGS4DgIr4CUmBVKYa8ZA5JLFLx3u+F08UDcI6K2Gr7mFkPwN
         15jQYtbipPBg0mtR0nPNxBUA4nOQGx2i+6bCSxqnxusBSYoIfcVRzPS99L9zncgS37Ot
         vW7w==
X-Forwarded-Encrypted: i=1; AJvYcCWeA8kcAETPfzrmEzzd64gR0a9PTKnuv1itr1KMtWRCq9UmoBD2FYUkLvBY0L5aFAu7q1ARRU9p0d/j/+rBwcmP53UsLw6k
X-Gm-Message-State: AOJu0Yzzkv3GpESItnoFq/NmtQTXzv7XsMi/pLG3mogWV27/nhe/+IRG
	BpR3l2JNUAfxMiEHDb1+QpetqqZrELOOIIqjuJD5RgB6cgI4SAv1x2da4Jo3Vwx/Bu0coD19ALa
	Y0GJlasPf77rexNWngGeVX19tmJU=
X-Google-Smtp-Source: AGHT+IHvahgzeBUUX4hz/RUp4Upi1wtnuxBy9GoDVguowxMVD0/mod1bCS/jaOMscbexoMQXSs9Ivs1glo+qGKR4lrQ=
X-Received: by 2002:a4a:dfc3:0:b0:5a1:2059:5763 with SMTP id
 p3-20020a4adfc3000000b005a120595763mr3245670ood.5.1709550136126; Mon, 04 Mar
 2024 03:02:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229041950.738878-1-xiubli@redhat.com> <CAOi1vP-hp7jmECXP4WNDT801qmBBZJjnUm0ic61Pw-JgipOyNw@mail.gmail.com>
 <10abc117-a0e8-47ab-b9e2-05424c358c4e@redhat.com>
In-Reply-To: <10abc117-a0e8-47ab-b9e2-05424c358c4e@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 4 Mar 2024 12:02:03 +0100
Message-ID: <CAOi1vP_=qP0EQTEAaJ2teA8PE1cBXDO0bc_KoRBYxf9jwA4iwA@mail.gmail.com>
Subject: Re: [PATCH] libceph: init the cursor when preparing the sparse read
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, stable@vger.kernel.org, 
	Luis Henriques <lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 2:02=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 3/2/24 00:16, Ilya Dryomov wrote:
> > On Thu, Feb 29, 2024 at 5:22=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> The osd code has remove cursor initilizing code and this will make
> >> the sparse read state into a infinite loop. We should initialize
> >> the cursor just before each sparse-read in messnger v2.
> >>
> >> Cc: stable@vger.kernel.org
> >> URL: https://tracker.ceph.com/issues/64607
> >> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available=
 on the socket")
> >> Reported-by: Luis Henriques <lhenriques@suse.de>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   net/ceph/messenger_v2.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> >> index a0ca5414b333..7ae0f80100f4 100644
> >> --- a/net/ceph/messenger_v2.c
> >> +++ b/net/ceph/messenger_v2.c
> >> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_=
connection *con)
> >>   static int prepare_sparse_read_data(struct ceph_connection *con)
> >>   {
> >>          struct ceph_msg *msg =3D con->in_msg;
> >> +       u64 len =3D con->in_msg->sparse_read_total ? : data_len(con->i=
n_msg);
> > Hi Xiubo,
> >
> > Why is sparse_read_total being tested here?  Isn't this function
> > supposed to be called only for sparse reads, after the state is set to
> > IN_S_PREPARE_SPARSE_DATA based on a similar test:
> >
> >      if (msg->sparse_read_total)
> >              con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA;
> >      else
> >              con->v2.in_state =3D IN_S_PREPARE_READ_DATA;
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

Hi Xiubo,

I suspect you copied this test from prepare_message_data() in msgr1,
where that function is called unconditionally for all reads.  In msgr2,
prepare_sparse_read_data() is called conditionally, so the test just
seems bogus.

That said, CephFS is the only user of sparse read code, so you should
know better at this point ;)

Thanks,

                Ilya

