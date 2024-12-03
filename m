Return-Path: <ceph-devel+bounces-2236-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB629E1CF0
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 14:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F299CB31A79
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 12:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226171E492D;
	Tue,  3 Dec 2024 12:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="ICjuNhDF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD85F1E048B
	for <ceph-devel@vger.kernel.org>; Tue,  3 Dec 2024 12:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228469; cv=none; b=TUcsd2Y0QcoOMEGcf9VpcBQ6bv/Nug3OHyCUzICypzdlfeUCc3gTc/J2Fu4gemimTxtM2GgZDVpOl5ctYSKMFlls4UDaxGQue+0hIMa5wwqOCyoChRFbuUL87RcC+6fuj9TBSGEoFa6SZAq514H1YilKjhcixz+EHXB2+Uoa91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228469; c=relaxed/simple;
	bh=1WImKTFIXOmnid3RYi3wzcqOj3BPOQI6o3xUPdhcFHM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mI7qo8UprghFClO8x+I1KqkUIaAgV3lK+9bOB9T65B0zqLTND7n+BK7qs7otZnduLjLodzcD3SruEIAly/9U8IpjXzEsl5cILBcOE5pvAVgCaMqs86jh7OMfXxuGokQMs5oCNXxiuB9NxXDgh6prWw0I1MrTyhtNGptSTxzkvFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=ICjuNhDF; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa53ebdf3caso258597266b.2
        for <ceph-devel@vger.kernel.org>; Tue, 03 Dec 2024 04:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733228466; x=1733833266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WImKTFIXOmnid3RYi3wzcqOj3BPOQI6o3xUPdhcFHM=;
        b=ICjuNhDFjYor4tRS3Vakn5n3YoTmX2DZonPbqp4VNKYEY39gZm3niP0BU2lcfQqZql
         /cu+xtvauwoCaYHQhkLWVCaxs5ebzddVAz2kibYeJbp6riyX+5sgcPyAGnCMSeSpNMiF
         wu6+FgtR9qEpr5wRhNluf1mo8XTPJDDYupT2CN05+KChmVORoEXMYFtBPEqlnpjJ97mv
         5cf98xAwnW/rq0Ace23lbTTSxuCrMvw+IgCLcrFLUq47atA8JgW7g9xzA25z9X9OVX2D
         wJq6gLL6Av7ZbGq7TSxDhkFkIM8RdT4pMMqiO4GldWXgJYEuyNEEGKwxeKBxYdknqMIv
         Vp6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733228466; x=1733833266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1WImKTFIXOmnid3RYi3wzcqOj3BPOQI6o3xUPdhcFHM=;
        b=HJ0pwrkIrCWD8mtHCAQS4x6Ses/QVZ6JXp/AUaX8GG6EQ4pKYIq1yDujNX+JGxFjvd
         LdtI0ygzLSfqx1BYnOwBgR+m2ygUm9+x8F/539qC0t/AVWUPpNPg7T3EGtzC0vUB3ya4
         H9fv2BRagDCsDVN0+3BXSpDdBm5K1GgQfXzFrRUCOTVlLUz+Y5IzXn46/TrH8NaFBxqG
         FV/GkAnnJOYBqfl2qoKQ3B9HHj0hubXpxL/dbxbH5CWc+or5l1KPIh/dr/AvSx56jQOu
         IEUD0VwT7+aCBVMhAYckN2OHZOr7qio7gCUm1lshrnMcCvi18G7oxf7t1GyL/WMKSpj2
         fwJw==
X-Forwarded-Encrypted: i=1; AJvYcCWTP+zd3H9Xa4V6EimYCzpVS7d2Bn/5qUwethblSAjy8pdlUkNqHJAAWRMrjna1byVxeZlZysXNYOqK@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0fTZUIQMgADhLU0if1jC+j1BhQO6YO7/W7tbUtb5HkxiAoQ6z
	pVo6qf38udwg4Lc7QiNajWWvKEslR7jX+z0p2A+y8ZoEVuFNvEMH2v/diGVlXlGBXb55uE1YLMs
	r+9ehPVAz0Jy0alFtoJF5FBpwfxbDdiYVP/euHg==
X-Gm-Gg: ASbGncvbsfUgSNmtYpKa/dP4FIfJklbYsy34eTfjRGKzwfIzhcyc0BAyi51dqGndLKT
	ukYsyHVSHCqVFb3Wsc2J/9/HVasr+VAyNBwQa9L5yf3Y2idF2MpY/5Dyij2s1
X-Google-Smtp-Source: AGHT+IECgoPf7qHpNyXgItUjiYOWa+tp6n6p4rrfllPoXDocCVMcuQlttw8uJtNTEg/Pe8c6cPGDTSHhCImfY9HBpRY=
X-Received: by 2002:a17:907:774c:b0:aa5:2bfb:2ec5 with SMTP id
 a640c23a62f3a-aa5f7cc3150mr256183566b.5.1733228466291; Tue, 03 Dec 2024
 04:21:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
 <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
 <c32e7d6237e36527535af19df539acbd5bf39928.camel@kernel.org>
 <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com>
 <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
 <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
 <CA+2bHPZW5ngyrAs8LaYzm__HGewf0De51MvffNZW4h+WX7kfwA@mail.gmail.com>
 <CAO8a2SiRwVUDT8e3fN1jfFOw3Z92dtWafZd8M6MHB57D3d_wvg@mail.gmail.com>
 <CAO8a2SiN+cnsK5LGMV+6jZM=VcO5kmxkTH1mR1bLF6Z5cPxH9A@mail.gmail.com>
 <CAKPOu+8u1Piy9KVvo+ioL93i2MskOvSTn5qqMV14V6SGRuMpOw@mail.gmail.com> <CAO8a2SizOPGE6z0g3qFV4E_+km_fxNx8k--9wiZ4hUG8_XE_6A@mail.gmail.com>
In-Reply-To: <CAO8a2SizOPGE6z0g3qFV4E_+km_fxNx8k--9wiZ4hUG8_XE_6A@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Tue, 3 Dec 2024 13:20:55 +0100
Message-ID: <CAKPOu+_-RdM59URnGWp9x+Htzg5xHqUW9djFYi8msvDYwdGxyw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Alex Markuze <amarkuze@redhat.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 3:33=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
> You and Illia agree on this point. I'll wait for replies and take your
> original patch into the testing branch unless any concerns are raised.

How long will you wait? It's been more than two weeks since I reported
this DoS vulnerability.

