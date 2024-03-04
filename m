Return-Path: <ceph-devel+bounces-952-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D8A870007
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 12:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 490AE1F265EC
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 11:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B678538392;
	Mon,  4 Mar 2024 11:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYoWSDpY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53FD381A0;
	Mon,  4 Mar 2024 11:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709550781; cv=none; b=InYFGXAYuOPa1rLzZp0v1G2333jv+kkFwJCP2GnqtP67ZXB9zRPVQxRurN0slr8wSWv+Z6u0qt4yFvjmIK5gZXAkbFLD+4fFrxNYLkLVD7N55a46YuL24a4nqQzgdHLEhtvdSyawQ2HyaGeUxBFrjOMou5U5cphNBvZSFCpb5pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709550781; c=relaxed/simple;
	bh=bBFgGv1uzwiSC74/VG1tPVfnABdHIQnAVE5a2/nbY6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rgYXN/IZLonRPu5h/Xn3NtKxV48gv9SbLjTnyDzJkeluU17EBJmmpxNYd1TW8VX1mU/PBGnaGwB0M06n96+ag8JXUcue72QboS3CLvNI5eFYFI+DTP2XNc2EAz6GsNg92iIuHq2RfI6E+lHx/HpNm9UKflEWJmSuM43QsecQeuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYoWSDpY; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-21fdf31a154so2469040fac.3;
        Mon, 04 Mar 2024 03:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709550779; x=1710155579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vb78VtFyXZfR94b6vTZZCTqsOufZq9YMppe4eS0rkTs=;
        b=PYoWSDpYMynsV4wQ8pS0sRLvIJhB9GUaGI2gya9WcWn+2QkiLNE8CNq+bZ4ZZS9UDT
         iQwSzCn8/h0k+Cy3owivbZQUUYoj4DSu6Pj+LjYecWJ0n7sxVqb7P2iHfXcvYcj1eenr
         kh/jSssURpdqKKdj8jtGNqvNrvIiWDpBwFUgJs+mP2sD7BAiW8Awbw6Bm7cX1Jz8b9Bh
         xWgvfIfkry4VFv3aGqlEdnvmr0A90vbYOCAFnAGyyiT+E/cXNDUxax/drbKZ3fq14DID
         xXkshiQnnpq0ijXVg6rUhvrxo3owpAv9ZGCqOEFNFfkrvmILMcvXcqh2uzCRUD5lHNCS
         ujGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709550779; x=1710155579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vb78VtFyXZfR94b6vTZZCTqsOufZq9YMppe4eS0rkTs=;
        b=GeuKi/myjKGvUTEjjWAARkjo0UQSLRDaiJTkl0rennU7E4cyEveHltTMZjTBhiBGEK
         pWR9xGBREyKPrTOkMk7P37TX/MzoYyVHWGZXUeXDglDhi8p6nWoC75f8x4gBMKH6do1b
         mxX4K2EMPguTArL9Zgrja7bh40bXTecXE+V/TBAxAD63vK4+Fzaw0HyuAR8BgfhkxFhe
         eRV9xVVNxrp1AGOBhq4QM3b8shuKcHkaVEecGNreNFxdZ2+xEoLCjiSruI66+rIdKZD6
         GkWU6kUfPS9+/6lrqznyPt6Oj9YBDd78PAkTC+8Sttc3PQQj/1x3KeisrQdljV4mxb7D
         EGLg==
X-Forwarded-Encrypted: i=1; AJvYcCUlUvvMXH0AvhHzW0dVDQmJHofJdouoM6gzZj2tUfd0DaleSxUIHm+Trg9SFKgBxEMgi9DSmA9S2mu6LIuxeHzQx9aCOT5c
X-Gm-Message-State: AOJu0YxdKgkLKE/2rpXLsYgslMBkYbL2u96YcAsQCZIyBMW3k7OpgWgZ
	FrMLXI5Lay4qpOOci+PTzrOZ564I15uHYljpRF0nHFfGaQmtJWMGu82nZo9HGnMvBawf3jIDaC8
	RJczOCTJJmyMPmC4WAR0LrLBxeiw=
X-Google-Smtp-Source: AGHT+IGyQAnwWpBE4NO+5e2HdYeKv4ioTCChCUX7ltsOCtUuFFv55Qj9xlBleWPOk6VHbn2HgWUfitHPU1bhEdl+1zA=
X-Received: by 2002:a05:6870:a92a:b0:21f:dc81:1c1a with SMTP id
 eq42-20020a056870a92a00b0021fdc811c1amr10306502oab.16.1709550778889; Mon, 04
 Mar 2024 03:12:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229041950.738878-1-xiubli@redhat.com> <CAOi1vP-n34TCcKoLLKe3yXRqS93qT4nc5pkM8Byo-D4zH-KZWA@mail.gmail.com>
 <6c3f5ef9-e350-4a1e-81dd-6ab63e7e5ef3@redhat.com> <CAOi1vP_WGs4yQz62UaVBDWk-vkcAQ7=SgQG37Zu86Q2QusMgOw@mail.gmail.com>
 <256b4b68-87e6-4686-9c51-e00712add8b3@redhat.com>
In-Reply-To: <256b4b68-87e6-4686-9c51-e00712add8b3@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 4 Mar 2024 12:12:47 +0100
Message-ID: <CAOi1vP-LFKzij5pYz+HLWAUiBZ-6+UYpoND08ceDofhN7xN-zw@mail.gmail.com>
Subject: Re: [PATCH] libceph: init the cursor when preparing the sparse read
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, stable@vger.kernel.org, 
	Luis Henriques <lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 1:43=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 3/2/24 01:15, Ilya Dryomov wrote:
> > On Fri, Mar 1, 2024 at 2:53=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wro=
te:
> >>
> >> On 2/29/24 18:48, Ilya Dryomov wrote:
> >>> On Thu, Feb 29, 2024 at 5:22=E2=80=AFAM <xiubli@redhat.com> wrote:
> >>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>
> >>>> The osd code has remove cursor initilizing code and this will make
> >>>> the sparse read state into a infinite loop. We should initialize
> >>>> the cursor just before each sparse-read in messnger v2.
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> URL: https://tracker.ceph.com/issues/64607
> >>>> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be availab=
le on the socket")
> >>>> Reported-by: Luis Henriques <lhenriques@suse.de>
> >>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>> ---
> >>>>    net/ceph/messenger_v2.c | 3 +++
> >>>>    1 file changed, 3 insertions(+)
> >>>>
> >>>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> >>>> index a0ca5414b333..7ae0f80100f4 100644
> >>>> --- a/net/ceph/messenger_v2.c
> >>>> +++ b/net/ceph/messenger_v2.c
> >>>> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct cep=
h_connection *con)
> >>>>    static int prepare_sparse_read_data(struct ceph_connection *con)
> >>>>    {
> >>>>           struct ceph_msg *msg =3D con->in_msg;
> >>>> +       u64 len =3D con->in_msg->sparse_read_total ? : data_len(con-=
>in_msg);
> >>>>
> >>>>           dout("%s: starting sparse read\n", __func__);
> >>>>
> >>>> @@ -2034,6 +2035,8 @@ static int prepare_sparse_read_data(struct cep=
h_connection *con)
> >>>>           if (!con_secure(con))
> >>>>                   con->in_data_crc =3D -1;
> >>>>
> >>>> +       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, l=
en);
> >>>> +
> >>>>           reset_in_kvecs(con);
> >>>>           con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA_CONT;
> >>>>           con->v2.data_len_remain =3D data_len(msg);
> >>>> --
> >>>> 2.43.0
> >>>>
> >>> Hi Xiubo,
> >>>
> >>> How did this get missed?  Was generic/580 not paired with msgr2 in cr=
c
> >>> mode or are we not running generic/580 at all?
> >>>
> >>> Multiple runs have happened since the patch was staged so if the matr=
ix
> >>> is set up correctly ms_mode=3Dcrc should have been in effect for xfst=
ests
> >>> at least a couple of times.
> >> I just found that my test script is incorrect and missed this case.
> >>
> >> The test locally is covered the msgr1 mostly and I think the qa test
> >> suite also doesn't cover it too. I will try to improve the qa tests la=
ter.
> > Could you please provide some details on the fixes needed to address
> > the coverage gap in the fs suite?
>
> Mainly to support the msgr v2 for fscrypt, before we only tested the
> fscrypt based on the msgr v1 for kclient. In ceph upstream we have
> support this while not backport it to reef yet.

I'm even more confused now...  If the fs suite in main covers msgr2 +
fscrypt (I'm taking your "in ceph upstream we have support" to mean
that), how did this bug get missed by runs on main?  At least a dozen
of them must have gone through in the form of Venky's integration
branches.

Thanks,

                Ilya

