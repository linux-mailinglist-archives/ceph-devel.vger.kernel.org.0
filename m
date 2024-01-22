Return-Path: <ceph-devel+bounces-629-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CBF9837240
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 20:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B12B71C2ACA0
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 19:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEA63DB86;
	Mon, 22 Jan 2024 19:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRd1UdAo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C853D570
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 19:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705950795; cv=none; b=aqU5ClWoQ5XO/boauenWgz7TIugaDQ69aU8D/F4ToHIpl2aBaU5M2P+c+GciutIMfojFd1tuqmwEgN/+mmoNZrTC0fYfAYusB7gG+o4Dlqdb+dg1EYbWXOZu5TDUEgHfiTA9pP2Y2rQrw0OGAEY/Zn4ehRmj/E830iNu3dwr1Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705950795; c=relaxed/simple;
	bh=h02Q+LSIon6Qe2NXEGVjoa0MJGyvhuDgxVUCLZ4AJEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I5eL6td+WSGwcFLDfZm32+GJ7dyXZ4GLcKQ0lsUSIG1eYYbSONk2KWyeXtnigjYlZ3qtJE/YWPqHvrefLCKI2JK5lCsgGt95Utje5EGwNrqPwIedcbXipkUfKua83et4PZnxyZ14X4v+1416cipGXYMYOcGqOZ8FS7N0vdPaNXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRd1UdAo; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-210a07b58f3so872453fac.2
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 11:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705950793; x=1706555593; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEof78q1se32pZTGWqWB+OFylFVCFKW3ddExRDb8rYM=;
        b=aRd1UdAoG9qEBhDc0WDwlIOnsfuCUnOmD+Ez5aWlp36WpPe2ET8y521BioRm/AFcrQ
         Q18tAjFyiC7kGj/2pjl3vytUe269gwua4z4mugJe5EbJjlySOhdk+ipFHE+2GCLBm7h9
         iVocwtFyKR96riSaSvwuVwYCN8C+tVIsqNo3JZbHMhE90BrceLrn6cn+baHyt2/s95nT
         ejKptxjmb1Kv+Uzy6s5/QaHF+8gSmXB047INiXxHGFaEN7klWZhGr4ZlRBPie3lNhK9r
         LH4Cy5xu74l4ahRgIZQTScK9l6WR3KVH0kQVKrBFMjERrRm6Y9MDRrQ2s/jpr6/5PvIM
         ejiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705950793; x=1706555593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEof78q1se32pZTGWqWB+OFylFVCFKW3ddExRDb8rYM=;
        b=MAsqRU+CIet0MBJSnAklYiG2Z4jLx6ZuuxFXqQbzod2fyIGOKMW2FTmHNwwWQ6oKBn
         yTyG2i+o8K62aG9YUz3QsYb+I8xey05mt+5a0ds+AwMHA/U/hqI0nyhW+JO3D31lhIPo
         6Jzy/1UA64/BlzCpMCpAiyBXp4+aFjPzZAs7nx+umIrtH6A8l92mDgqEHnrybKR9uHv0
         2NUgUWvQHRD93Lw0+MP9RqG99WPxlRCM+0uN8o97mLh1Nz+6MaxhoKQjAV/fK/edWvk2
         OBzxDuPFQfuzhrFZ+iizAP6ZJz5CJpo55/EijRX1YAHwmij/BnM3hBLbDadRcbfaCydT
         gDkg==
X-Gm-Message-State: AOJu0YzxgQVPLYWVLqq4Is1eVWwrJOsfFtgw/IFpGPy6Zy26AI3iXIiX
	y6IU6BEnG70NVkj9Z6nmq+lhmUnOqorrL/JyVfYZv3cdSn4aKqMGg7Ahtizc+/3oOWWcaDqQpyd
	fJ1qa0djbW5PJVP50HQ6td+V35cI=
X-Google-Smtp-Source: AGHT+IEgySMF5fgr8KkewJAok8S9qIoxTpGUZ8z9mLhkmE9VFIGrakaBJrS6tn4pmrYPuufWVGTBVRhnNCs8ECqKJOM=
X-Received: by 2002:a05:6870:9614:b0:206:b172:2a38 with SMTP id
 d20-20020a056870961400b00206b1722a38mr373279oaq.17.1705950793123; Mon, 22 Jan
 2024 11:13:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231215002034.205780-1-xiubli@redhat.com> <20231215002034.205780-4-xiubli@redhat.com>
 <CAOi1vP9ZOyNVC4yquNK6QUFWDr6z+M1e9M2St7uPhRkhfL7QPA@mail.gmail.com>
 <a1d6e998-f496-4408-9d76-3671ee73e054@redhat.com> <CAOi1vP8xOFA4QgMwjGyzTJuAC6T6+XDypXW3Dhhin0RnUh-ZAQ@mail.gmail.com>
 <68e4cf5a-f64f-4545-87b0-762ab920d9ba@redhat.com>
In-Reply-To: <68e4cf5a-f64f-4545-87b0-762ab920d9ba@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 22 Jan 2024 20:13:01 +0100
Message-ID: <CAOi1vP_Ht9xM=k5FvXEnjAOP0kvp_rebpz+ehvmGoaOZXgMhwQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] libceph: just wait for more data to be available
 on the socket
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 2:26=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 1/16/24 18:00, Ilya Dryomov wrote:
>
> On Tue, Jan 16, 2024 at 5:09=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrot=
e:
>
> [...]
> I was waiting for Jeff's review since this is his code, but it's been
> a while so I'll just comment.
>
> To me, it's a sign of suboptimal structure that you needed to add new
> fields to the cursor just to be able tell whether this function is done
> with the message, because it's something that is already tracked but
> gets lost between the loops here.
>
> Currently this function is structured as:
>
>     do {
>         if (set up for kvec)
>            read as much as possible into kvec
>         else if (set up for pages)
>            read as much as possible into pages
>
>         if (short read)
>             bail, will be called again later
>
>          invoke con->ops->sparse_read() for processing the thing what
>          was read and setting up the next read OR setting up the initial
>          read
>     } until (con->ops->sparse_read() returns "done")
>
> If it was me, I would pursue refactoring this to:
>
>     do {
>         if (set up for kvec)
>            read as much as possible into kvec
>         else if (set up for pages)
>            read as much as possible into pages
>         else
>            bail
>
> Why bail here ? For the new sparse read both the 'kvec' and 'pages' shoul=
dn't be set, so the following '->sparse_read()' will set up them and contin=
ue.
>
> Or you just want the 'read_partial_sparse_msg_data()' to read data but no=
t the first time to trigger the '->sparse_read()' ? Before I tried a simila=
r approach and it was not as optional as this one as I do.
>
> Hi Xiubo,
>
> I addressed that in the previous message:
>
>     ... and invoke con->ops->sparse_read() for the first time elsewhere,
>     likely in prepare_message_data().  The rationale is that the state
>     machine inside con->ops->sparse_read() is conceptually a cursor and
>     prepare_message_data() is where the cursor is initialized for normal
>     reads.
>
> The benefit is that no additional state would be needed.
>
> Hi Ilya,
>
> I am afraid this won't work if my understanding is correct.
>
> I think you want to call the first 'con->ops->sparse_read()' earlier some=
where such as in 'prepare_message_data()' to parse and skip the extra spare=
-read extent array info and then we could reuse the 'cursor->total_resid' a=
s others, right ?
>
> As we know the 'cursor->total_resid' is for pure data only, while for spa=
rse-read it introduce some extra extent array info.
>
> For sparse-read we need to call 'con->ops->sparse_read()' several times f=
or each sparse-read OP and each time it will only parse part of the extra i=
nfo. That means we need to call 'con->ops->sparse_read()' many times in 'pr=
epare_message_data()' in this approach.
>
> The the most important thing is that we couldn't do this in 'prepare_mess=
age_data()', because the 'prepare_message_data()' will be called just befor=
e parsing the "front" and "middle" of the msg.

Hi Xiubo,

I see, I missed that in my suggestion.

>
> Else if we did this in somewhere place out of 'prepare_message_data()', t=
hen we must do it in the following code just before  Line#1267:
>
> 1262         /* (page) data */      1263         if (data_len) {        1=
264                 if (!m->num_data_items)              1265              =
           return -EIO;                         1266    1267               =
  if (m->sparse_read) 1268                         ret =3D read_partial_spa=
rse_msg_data(con); 1269                 else if (ceph_test_opt(from_msgr(co=
n->msgr), RXBOUNCE)) 1270                         ret =3D read_partial_msg_=
data_bounce(con); 1271                 else           1272                 =
        ret =3D read_partial_msg_data(con);    1273                 if (ret=
 <=3D 0) 1274                         return ret; 1275         }
>
> But this still couldn't resolve the multiple sparse-read OPs case, once t=
he first OP parsing finishes we couldn't jump back to call 'prepare_message=
_data()'.
>
> The sparse-read data in the socket buffer will be:
>
> OP1: <sparse-read header> <sparse-read extents> <sparse-read real data le=
ngth> <real data 1>; OP2: <sparse-read header> <sparse-read extents> <spars=
e-read real data length> <real data 2>; OP3:....
>
> Currently the 'cursor->total_resid' will record the total length of <real=
 data 1> + <real data 2> + ...
>
> And the 'cursor->sr_total_resid' will record all the above.
>
> The 'cursor->sr_total_resid', which is similar with 'cursor->total_resid'=
, will just record the total data length for current sparse-read request an=
d will determine whether should we skip parsing the "(page) data" in 'read_=
partial_message()'.
>
> I understand the intent behind cursor->sr_total_resid, but it would be
> nice to do without it because of its inherent redundancy.
>
> The above is why I added ''cursor->sr_total_resid'.
>
> Did you try calling con->ops->sparse_read() for the first time exactly
> where cursor->sr_total_resid is initialized in your patch?
>
> Yeah, I did but it didn't work as I mentioned above. If I am wrong, pleas=
e correct me.

I think you are right, and also in that introducing a separate field
makes for an easier fix.  I continue to claim that a separate field is
_inherently_ redundant though -- it's just that due to the structure of
the current code, it's not obvious.

There is definitely a way to make this (to be precise: allow
read_partial_sparse_msg_data() to be invoked by the messenger on short
reads of the footer without causing any damage like attempting to parse
random data as sparse-read header and/or extents) happen without adding
additional fields to the cursor or elsewhere.  But it might involve
refactoring the entire state machine such that information isn't lost
between the messenger and the OSD client, so I'm not asking that you
take that on here.

I wouldn't object to cursor->sr_total_resid being added, I just don't
like it ;)

Thanks,

                Ilya

