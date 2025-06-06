Return-Path: <ceph-devel+bounces-3072-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83AF8AD078B
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 19:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD99E3A670B
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 17:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF4E288CBC;
	Fri,  6 Jun 2025 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="XxeyvBj6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1D91DF24F
	for <ceph-devel@vger.kernel.org>; Fri,  6 Jun 2025 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231272; cv=none; b=Zq8csKp7ST0lndiL1SCLkXO/8o+jqokHXcwlqgmKLVVbxv8gwLbXcQWeAMsQBh0yN806VFOzmFv5UKGraQ/pQevyrSz5/t8wff6uFmV+8mL3qw7Vgkza1W7pml2/0R8o0XZxQVucm3+TY3Gvm9W/cSWrRuQwlzjDm5oXc6qn25E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231272; c=relaxed/simple;
	bh=Lo2sLUU8gajP/2fa2TGn/MAv7u50Q7/UTg9+NcgakJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SzqwrIjsfi1/eU3nioGhRK3K50Mtee1rIxoPpaQ0q1S771lTueStiHTAgPBUf60ECM0Ih2K3Ki79wDTgwSDD0qiccEPl7CT1OGXvZupnIU7bGgxyXgRaUpCDnKb84CA2FerUWy0uXHhh2OmWFNnMRfjzBEuFP5B7PcfavMay5qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=XxeyvBj6; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-607434e1821so1987948a12.0
        for <ceph-devel@vger.kernel.org>; Fri, 06 Jun 2025 10:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1749231268; x=1749836068; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lo2sLUU8gajP/2fa2TGn/MAv7u50Q7/UTg9+NcgakJ4=;
        b=XxeyvBj6O4jxUxuFT27YlZT3WpVSmDWEt/MrTZNgLLFwNnbILUpioTwd+KaUIx/Dam
         kmp5yjpLIWn+bfqbH0jqlEDYAU+RWlvwrn2DQukHubmKUcTVg15DdpAXJDlx6K3uiKaA
         txdKDmQXeEwxt2Au+2QeQQR+gnGSNdpAq6VSaEAGCVteLBbXFk0bvd9UvjOj/NMvVMAp
         XN+W/+aEvcrm8F9h4ybaSzN2ubND8i8llOF+Ti20JspWBODN8L8FUbPpHQ9hSOKIGvfl
         M6ZB3fibPW8WqrNU9IYfaKva+Y97XhTbBJ48snQVaTkDVzU9jBEeskMsiECHyQY6pBU3
         Wvmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749231268; x=1749836068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lo2sLUU8gajP/2fa2TGn/MAv7u50Q7/UTg9+NcgakJ4=;
        b=SMWqcWvCTak+Fqqh2h4+lV9TxwjUR+M+QVjCjpLS90L9DMY8JeXRx4KQB2P3rjR/IB
         jJSy0789eRPdcn00sl6aPf/aTmYUEn+eBXTDP0WuC7Dowy6vJpqWpcBMAs59rxZ96UjP
         gQohosN5zXnM7623nKT8HS1hn46MgTIOGcW13IueMq3LMKEep+4O10KIoRRyOe8H7kOm
         PUqPmu480Ku/rVlN/qTyC+2gqaLnhqH71e1ZLt3ZSSex+TpP436EjYWcPnftf9sPeICl
         DYIkwVaz/yKWyAW92DKceP7tGZJNzKYjuZfuvINIJRqTXKGj0N89eW7De02vJ2D1o0c3
         JBxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlkm9etKO+d7Ls066B09AKD3B7fmCYYTdk5SsOgygH+GMC/VQLhxwS+2T4/XRQt2L3kuzyIVH+TYRL@vger.kernel.org
X-Gm-Message-State: AOJu0YyM9VFXQcic5Zra1vnAb0sipOvC+PtD0SFU65Rq4fSsr2KgmPRM
	o8xIsYGydRe8QgmMdnNEn6ux3HqbFtjhz4XUtEOJTy84a0b1eZlmdBnCSpeDZGObTdZsqw/Wg5h
	8DcpdFSl15LDgJ2kEn5dxy7ZTpfQy57UhH4mZaL0zEQ==
X-Gm-Gg: ASbGncvSpsUGUysbLJl7IvOjnaOQMuW1hWr13GJ1ZmJLB6qtoQmWmyEaAuPuC7h3GqS
	B0OW2eBcFQPxhIqpySAtCuFvYpCKN1kOIb9zaFa7YFL0THQ4ltsMW/2G5IPawUIP4fuSrV6CtZ7
	gqniuCWPjAjy6aNbvZJAG16UUfnK9Ns6Zu/r/BVW+j8pgIZNEHcqc41fHJ23NL3jIPBExEucNj
X-Google-Smtp-Source: AGHT+IFCETrTEmcPHz0ACqWVc876pXPxxfTtH+owoz2M0LztCGhL/1O23PMi+ver8XH+7oQ+N3Hc2WCimzLR1FZJO0A=
X-Received: by 2002:a17:907:970f:b0:adb:428f:f735 with SMTP id
 a640c23a62f3a-ade1aa5cfeamr398755266b.12.1749231268512; Fri, 06 Jun 2025
 10:34:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241206165014.165614-1-max.kellermann@ionos.com>
 <CAKPOu+8eQfqJ9tVz-DzDzqKPEtQVCooxtxe1+OZanu5gi3oQzQ@mail.gmail.com>
 <CAOi1vP-dARssCkj-2FiKDJLRv9+Dq+_GE3pfQy4BseF_8sjUNQ@mail.gmail.com> <b4ac9be24677c76a04c99aab04f572abaa4cf8af.camel@ibm.com>
In-Reply-To: <b4ac9be24677c76a04c99aab04f572abaa4cf8af.camel@ibm.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Fri, 6 Jun 2025 19:34:16 +0200
X-Gm-Features: AX0GCFuX9_ACdlLmbK9HuAeYg9WTPGsECRMNei5y1frnMXhguGJU97HHePkE5gQ
Message-ID: <CAKPOu+9GHo3_Uf+b_8-p0Hg=gdJJnRE62Go9UZz9WHqR6WF5Lw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "idryomov@gmail.com" <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, 
	Alex Markuze <amarkuze@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 7:15=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
> I see the point. Our last discussion has finished with statement that Max
> doesn't care about this patch set and we don't need to pick it up. If he =
changed
> his mind, then I can return to the review of the patch. :) My understandi=
ng was
> that he prefers another person for the review. :) This is why I keep sile=
nce.

I do care, always did. I answered your questions, but they were not
really about my patch but about whether error handling is necessary.
Well, yes, of course! The whole point of my patch is to add an error
condition that did not exist before. If locking can fail, of course
you have to check that and propagate the error to the caller (and
unlocking after a failed lock of course leads to sorrow). That is so
trivial, I don't even know where to start to explain this if that
isn't already obvious enough.

If you keep questioning that, are you really qualified to do a code review?

Max

