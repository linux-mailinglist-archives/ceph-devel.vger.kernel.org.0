Return-Path: <ceph-devel+bounces-3082-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9CAAD1E8C
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Jun 2025 15:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC0F016BE6B
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Jun 2025 13:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED7B2580E1;
	Mon,  9 Jun 2025 13:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4aMZJ8o"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338C02571DF;
	Mon,  9 Jun 2025 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749474810; cv=none; b=Y1ly7rfbySYJ+Lrta6ShXDptgVYCBpgAQ8aEvuPcDr+6hyyRyG8KvW15Fa7BjktskW7gWQZvVbz9aPEV6+JxxbNraDn5rtco+pnl89cXQzZDCzk5XNGlG2Kv+AJTh0lyjKEpeH/iknV31NxVGpk9hTYfIpGyrzdc+BIM1k/8YIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749474810; c=relaxed/simple;
	bh=+wn+GUTCxWhKm5C4rtRbTa/dFCAMSrFWEPKBqYycUwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sfON/rPiEyZquFZyouxgXoCX7dLB1Y5hLk3F8MYaosN5Ju3b1pbVNlXo83UJwLDD1I3rNeQDZlpe/aCInT9UvvJa+S5qZWUMlioH4Wmd5cbUqKudaf6X1gBKJ/nTQ1O4a+TBmzC29EiqjfdOSOJV90ETEM3vg1asvW2uo0nSAMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4aMZJ8o; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-309fac646adso4855739a91.1;
        Mon, 09 Jun 2025 06:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749474808; x=1750079608; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DDg7LibBWz3cpFPLspkhepRDBdIiwZ+2xqPXdI7z0dI=;
        b=P4aMZJ8oYZfOD/SSNc+l0nj54TohN+VBb9o5nzLBySYyN9oDsPpCdZi49JYY/mi1y9
         m2mKoH3jAqv3+AqDx54rMG0aJurhwJCyqq4TRkwUASzZvPvQw9XZa0nGVxPIW68coPLt
         qTCIyxW0yIRk1zdQW/NDhq2aY5NZul1GEH2nRO9VyvRs2OUjdo0NZ0XvyyNDApGwKt2B
         BXwvkqujq3ZmcAgQWIhKK3C87tyZsUHMgOln75XfREfJbaIpQ5bMnhxbWR+3tp0GU8KF
         d7bsNyjVjrUJCOTlLhYNJ7iVney2NDE+lU68rBNIWlVRS0gMjto7rVzYdZ9ZtZQCt+/J
         OnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749474808; x=1750079608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DDg7LibBWz3cpFPLspkhepRDBdIiwZ+2xqPXdI7z0dI=;
        b=pCD8T4cZcKVuTA+P1rUtzAbyiKB54w3gUP52A9d8aT9bhtorX3mJMmoe5V6OqON4nw
         3wTfeoGcEuxTbAsLbBQr7jgP3ikaF8BOYDT49gCCE5y3GquU7AEL0XwE3Am5U0IAF4OD
         XfldZuyOXH76LO1hE3yASF0FHcwv5MF8r62BzQsCf2M0y78AnbHe3NN6AE4I+fpYp2VD
         PbCz3mmRJW2liDAinywP23VA26U+cE9ttfHQEpVOd6EdqI1PLScdHIxWjprU5/ZdYG7A
         KEzBAETwMBBx5PV+CeF0XNlelammuD3A6H/TsVRBT1B+dFNmSLhXYA+u2f8oNUgv+fbf
         Dmrg==
X-Forwarded-Encrypted: i=1; AJvYcCU98koMhdWB/KNJi9JlrNGd2BSDHY3563GKf3cKv/0wvpO5tFUrY4ty3as0Cf7ZisLK4ooNOQDChMa88jJC@vger.kernel.org, AJvYcCUKXIKsMlpOoSGKaomsgS+OM70XVCP1Nc6GxRoRVTgJr4u4eIR28nJbKGTUSI+d+suHnOiMmJySp7Sr@vger.kernel.org
X-Gm-Message-State: AOJu0YzUmw+nd4daDCGyQsw7sI6NgKKtzyzbaTkVg6N0h1fmmQDPkZea
	M91ZJ5z8k8wsv1b9UFLxnXmb0rJ/Mjg4sUvnv531i4sJRAs/ua7JZ3swsvYLl7TpBtlQ/aH0pl4
	FJjN1n5Uwnt9Rnk5WebVGncu5Rgm1maA=
X-Gm-Gg: ASbGncsrjg8iAtlS6A1vP/T2b5VJ0DJUbdHOHsa0RI5mh4urpd79xbSrwSLHT81Zs0f
	dX0pImnJ1y5pF0Afnrxiy4VkW47BgDzgdl7I46BwLtby0UOLYzVvTxZ4tPJtF9cAcVw4KGx8a9L
	kuyPjpel5fYLAv9Z24P4gJAX6HjFFEygsm8oIdtWz0kms=
X-Google-Smtp-Source: AGHT+IGh33UQEi+aV25CCQ6eL9GqjN8Y25pZE9QJjU89kXG0wpRZ9JY3LC/PA5sryW9aYBvGmBMUfMloKh5mhylD6No=
X-Received: by 2002:a17:90b:5866:b0:311:be43:f09a with SMTP id
 98e67ed59e1d1-31349f53ea6mr17545908a91.9.1749474808309; Mon, 09 Jun 2025
 06:13:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241206165014.165614-1-max.kellermann@ionos.com>
 <CAKPOu+8eQfqJ9tVz-DzDzqKPEtQVCooxtxe1+OZanu5gi3oQzQ@mail.gmail.com>
 <CAOi1vP-dARssCkj-2FiKDJLRv9+Dq+_GE3pfQy4BseF_8sjUNQ@mail.gmail.com>
 <b4ac9be24677c76a04c99aab04f572abaa4cf8af.camel@ibm.com> <CAKPOu+9GHo3_Uf+b_8-p0Hg=gdJJnRE62Go9UZz9WHqR6WF5Lw@mail.gmail.com>
 <5d195404b0c997b65633eab4c0326c9c9466bd85.camel@ibm.com>
In-Reply-To: <5d195404b0c997b65633eab4c0326c9c9466bd85.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 9 Jun 2025 15:13:16 +0200
X-Gm-Features: AX0GCFvOQgB1ztNay1Ww07qkx-epqxnV_lBa6bvknvTXAEykj7ZmxkVapRrrA6U
Message-ID: <CAOi1vP_QGYdLPyK8fp5Aoz_Pahr+0Fbu=4LWgAgjyTJtba80uA@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "max.kellermann@ionos.com" <max.kellermann@ionos.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 7:42=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Fri, 2025-06-06 at 19:34 +0200, Max Kellermann wrote:
> > On Fri, Jun 6, 2025 at 7:15=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyk=
o@ibm.com> wrote:
> > > I see the point. Our last discussion has finished with statement that=
 Max
> > > doesn't care about this patch set and we don't need to pick it up. If=
 he changed
> > > his mind, then I can return to the review of the patch. :) My underst=
anding was
> > > that he prefers another person for the review. :) This is why I keep =
silence.
> >
> > I do care, always did. I answered your questions, but they were not
> > really about my patch but about whether error handling is necessary.
> > Well, yes, of course! The whole point of my patch is to add an error
> > condition that did not exist before. If locking can fail, of course
> > you have to check that and propagate the error to the caller (and
> > unlocking after a failed lock of course leads to sorrow). That is so
> > trivial, I don't even know where to start to explain this if that
> > isn't already obvious enough.
> >
> > If you keep questioning that, are you really qualified to do a code rev=
iew?
> >
>
> OK. If I am not good enough, then somebody else can do the review. :)

The patch looked sensible to me, so I have picked it up into the
testing branch after some massaging as part of my own review:

https://github.com/ceph/ceph-client/commit/837b07491efc3e21cf08732f0320ce3a=
c52951f6

I tried to consider Slava's comments while at it.  AFAICS the points
raised were: the need for __must_check to begin with, whether the new
error needs to be propagated and the comment on compiler_attributes.h
include.

For __must_check itself, I kept it -- it makes sense because ignoring
the return value would be a straight ticket to lock imbalance.  Slava's
observation may have been that there are many similar scenarios where
__must_check isn't used, but that can't serve as a justification for
not adopting __must_check IMO.  It's also there in the corresponding
NFS patch.

Propagating the new error also makes sense to me -- I don't think
CephFS does anything special with EINTR and control wouldn't return to
userspace anyway because of the kill.  I don't see how "we simply need
not to execute the logic" behavior is possible without returning some
kind of error to the caller of e.g. ceph_read_iter().

For the comment, I dropped it because __must_check is very obviously
tied to compiler_attributes.h and such comments aren't common.

As I was touching the patch, I formatted the ternary if statements to
fit the rest of the Ceph client code more (despite inconsistencies none
of the existing ones are formatted that way) and made the return type
to be on the same line and __must_check come after it as per the coding
style (Documentation/process/coding-style.rst).

Thanks,

                Ilya

