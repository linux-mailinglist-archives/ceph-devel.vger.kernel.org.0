Return-Path: <ceph-devel+bounces-3652-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4E4B819B8
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 21:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8444F165225
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 19:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DE22FD7CD;
	Wed, 17 Sep 2025 19:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="APxIxzAu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB521578F
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 19:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758137165; cv=none; b=RHxzhwMrTtIm1G/iv7YIUZX5nPXfsGNWQ25SKx8oXJQ60G/VZIZS74khOu5n0BJAnPFQy/c1lUEEgPs6MbPVvco0l0oPI0reORic6qws4I5w+JhevPbH1pGhNot+doql3j1XsVlXM4EXgnYvIq8ymYY/Wr+CmmHhsceMxq7TwBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758137165; c=relaxed/simple;
	bh=rnRQh1fgG/iBS/92Mk0NI/PnJazDMk7alTWmgTAbA0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uymi26DootIG0Y9xzTd9f4V+oZVKgJ1jCC81rZzS49opwMfatVW4k49G/78kTwdY4pU1QJLEeVPRlm4SQ+XPfT9R4mHFL0xPxznFPyrdrAcFdke2Q0iCCvnrnUi3PJjoQHPvzThDEwWam3eFsEp0/KdhmMpzw9SJWqh0dU68V+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=APxIxzAu; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b07c081660aso30183366b.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 12:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758137161; x=1758741961; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gM73047ejBdI07SXB7vIlmIGMpwYKQFcM4Zm+pCZ9bo=;
        b=APxIxzAurGpDGUBI9zQAJK7Hevf9cPrI/8seWcloFvTdDqPcFtINSys63QyTqYRytw
         qsQ27bAmXJnNIXnr9p5kxjRLoYQtve/qM1gtGnqTZrk9szQ+XGusBJBKBP3VmVEG8bHz
         KChjYmNLR+gBU+uLUO536WTol8mcBRN14NUY9MA0G7sN8ZSCBuu9uzgCq60eZWCAi68y
         Vv0YqhSvx96V/xy1YRlKrvr+MVOlkkBU6uLsu8HF1+z9u3tjgWFOSA8eT0IIwLpzlVH2
         tBmZJMPPntFbaxFbtRwa6snbS1PYw/yoviHWY+Ph/NsV7YypVtACtSgFxYZ2HI5P3Akk
         iCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758137161; x=1758741961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gM73047ejBdI07SXB7vIlmIGMpwYKQFcM4Zm+pCZ9bo=;
        b=qAQnb3CjfAuJILRUB1/mnn/WexUYqHwlIA1tEr4qD9Mruy2gEB+IeDjVk1zkNgzFe3
         EVpVUtZQDRdamGrAqBfhReRS+hTYK2scThT0KkbPnEg0fNt3HAVthRICfVgB8ptBEcqx
         rBzHCMRYnAB6B8EWnX6flEC5heLHqzPmQP3Yz5+iapBAkaKTNRd0i86UonhCLZokoyKf
         SzrMIBAdZX5YUsgNIg2K3wuKuGz+/sWAn5GKTWfTulb6/72fp5Nd/mCOI0pnCoTLGN6J
         SaXzOo662VM1BQa1Vmlg3DLT2gjYvQKmIrcCiGazLlnAe4+mDlkk32XLlvdJgKWcI/wa
         eGkA==
X-Forwarded-Encrypted: i=1; AJvYcCUhhSMsfh6s6E0XmAg0SzUy7OIpReJgEmM8xYLHNatqvQ+yWQNGQalhtZkLP+P1uCF1aDyg/HWHfNMV@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1gF1+KkFBEXFhphjssZ4us10iJQfZRF7Km7KEqUC0GaJBtc82
	RnkufyQHuh4/iUMjFIbxVmt90niXF76rmwoZfSCPUkGWv9tQYJWVOSNdBhkC4ChCBr4drLgeRDm
	mQhW/C9WoilZyZXa5e2vZTkimZPKpB+wEZZA7nftE1Q==
X-Gm-Gg: ASbGncvj6gF27hoprWm6Y3/LgA95w2QmShKjMLr/ZMEoOAIKxviA0DvlV1tv2A9XiiI
	TNK4bd4b9kkhPsw7/AV+XMeTMcjeXZTqr+uoLhOZVlrbvmU/opOjAI5QpkNcR8sFkrafXf2SUys
	gp19yrUVVZisRe8ShPz/bUi6fRr5/OSUJB2UDTcNXC1UHiSwMSllUrTNzSSc9uZjI7SoUWJeeGE
	XI46qlbMDHiETp3JQ3E1UAoFrf6VmB9aSnl
X-Google-Smtp-Source: AGHT+IHV+j4kzgnlA17vMPfFNZMuPAmy/0tGoISSJII60cK9xhE9rBFeexcHdz76p+ynPHs9naBObYA9aHQI2oTrR4o=
X-Received: by 2002:a17:907:944f:b0:b04:9468:4a21 with SMTP id
 a640c23a62f3a-b1bb739e7f5mr341249166b.14.1758137161567; Wed, 17 Sep 2025
 12:26:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917135907.2218073-1-max.kellermann@ionos.com>
 <832b26f3004b404b0c4a4474a26a02a260c71528.camel@ibm.com> <CAKPOu+_xxLjTC6RyChmwn_tR-pATEDLMErkzqFjGwuALgMVK6g@mail.gmail.com>
 <3c36023271ed916f502d03e4e2e76da711c43ebf.camel@ibm.com>
In-Reply-To: <3c36023271ed916f502d03e4e2e76da711c43ebf.camel@ibm.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 21:25:50 +0200
X-Gm-Features: AS18NWDOAnSLj0nw3kPAv4b-NSgo8QkEB21FLGzoG6YC2RFaOsN704wTATLg6Fg
Message-ID: <CAKPOu+8b_xOicarviAw_39b2y5ei9boRFNxxkP19zE5LGZxm=Q@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"netfs@lists.linux.dev" <netfs@lists.linux.dev>, Alex Markuze <amarkuze@redhat.com>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"mjguzik@gmail.com" <mjguzik@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 9:20=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
> > > > +     WARN_ON_ONCE(!queue_work(ceph_inode_to_fs_client(inode)->inod=
e_wq,
> > > > +                              &ceph_inode(inode)->i_work));
> > >
> > > This function looks like ceph_queue_inode_work() [1]. Can we use
> > > ceph_queue_inode_work()?
> >
> > No, we can not, because that function adds an inode reference (instead
> > of donating the existing reference) and there's no way we can safely
> > get rid of it (even if we would accept paying the overhead of two
> > extra atomic operations).
>
> This function can call iput() too. Should we rework it, then? Also, as a =
result,
> we will have two similar functions. And it could be confusing.

No. NOT calling iput() is the whole point of my patch. Did you read
the patch description?

