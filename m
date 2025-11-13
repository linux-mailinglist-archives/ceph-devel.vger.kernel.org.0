Return-Path: <ceph-devel+bounces-4034-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03EB5C57DF7
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Nov 2025 15:16:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B71F4A5B32
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Nov 2025 13:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F56923D7F0;
	Thu, 13 Nov 2025 13:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lHkVxtj4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F2125393E
	for <ceph-devel@vger.kernel.org>; Thu, 13 Nov 2025 13:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042215; cv=none; b=QwEu3+fucM0oS0E3+xDBOt9iFDTqCSm+tXKIL4HAEx8j4kVfFgF5w+2mGbPGBTMciPK+tUsUbvl9UxRCxHAs3Ua5fsjNvgMDLkV1ySpMW5F8GNFEFy2lsyU5g3P7xlAjf93izthAHIgaCEXElZIvjSPvrMXJ7c9YhmK2kg6bjg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042215; c=relaxed/simple;
	bh=tOT1HSylb1QN2WLEh7CO5w+hg9dwoeBIKHjNTKOhbjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GNZfT7oOMHEExKNlu1Ak+Lbf+uRwYBU2b9+gBfGaTULCXKNazi7p65zxBBwKd7I02X4xO9UU1az5UbO3a34rR1L0BSZMTX5YiP2OPFdqcMjq4IjYj64afX9ctLMEmBTDIy2VL9ip2HGCZxXythi5u3I3uDYyItA+gvkTXMFBZ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lHkVxtj4; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29853ec5b8cso8610405ad.3
        for <ceph-devel@vger.kernel.org>; Thu, 13 Nov 2025 05:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763042214; x=1763647014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F17eSc9DJ9T59+bKrH8TjFz8cIjyB5zo77rFUMfx2HI=;
        b=lHkVxtj4a0ESUxg765B44ZhGyfkreVbvjGHgK+/lXga4+BVHbdAk/UdpIcuvDLH2Ps
         XaBtCGga+t5kbHyoZtkGA1Ie75mtyAiOtZswweYS6Lit08fhV07B1kyUNuNerh6UX+17
         JLrpYRONb1JWzRc5z9vhyvlkYVtOxvYX4jmU3k2vH7nYW4TgtFujIoohXNzYcxfdvxz0
         T5nU9cOUG154LZ/5nBIpHvpvBiy3yIhVIbZAzpzJcdxACKv2CrvnOKxAyzeIkHkilDG3
         bTKHu3tfglE0nuCR8MDycPeG6s6iuSjvYTFfTROPtLtsWTuc3LSnPDKlj2AK3RAK1C9D
         nYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763042214; x=1763647014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F17eSc9DJ9T59+bKrH8TjFz8cIjyB5zo77rFUMfx2HI=;
        b=JL3Xf6w0vS+nssmT0WsrRkVdWWkg14FM/bjc6iqDUoF/Yl9YLq62vx+ivG5RcMptcs
         DZ5bcK0+d5v1twZAvWodcPADwfzHSpZ+PorD/V4mKFi3CFWpNC0cIIVF45LAVHY7KFmk
         g5h3BTc5rse9UYQb2t2bD6Neib0SIYYo+9oUlUMVF2Q/j0UPOQTI22Z/cm31MPn+b1a5
         Sb8QbT2tw1uDEL29SY+dOzJnuF32iTeXTNLvjNAnp55evsmR9ciC4mbfODxuzaQbzKxJ
         2G6SL9hqQsJOEJetQFh4VSBPksgD37FC/woklP3nU47D/C7/RKwQVlix16pyVF/XxUyt
         6LkA==
X-Forwarded-Encrypted: i=1; AJvYcCV60nhjXjBVgnmEFedBRdTcbBEMlVFrPhY7p2us0OLlEAAWnA5wgsbEGrG0R/5gaD6Jlb30ZByDLdbU@vger.kernel.org
X-Gm-Message-State: AOJu0YwmTy1HVzNYC680liNlO6AUy9HV2F/nwczpho0J9jMbtgynOAym
	fsQGqVFSQZm1HfXPoaSLu95lcoQtBhPkNGqxKaz+RuU2I/LN2H8Y9TA32OkDUOgLjuYar/vtEYd
	ZlKSx1fZyF20D2tCpmwtBd2+x0tloFrk=
X-Gm-Gg: ASbGncsmw53X//R0J2NohGoolaqyeannmCc4o/2kM7zEqBUZjaBaylUypXQX0NlPMzq
	DaxltHiIQC4XbVDmXW66gjxkM/fhCu8SUQae91WnkLRwYInqBgD3GdEqv5qWtT7M1yUr5Ozlaxz
	EXY/2EpEd8HMOKEB1BnWUc1Wpvq2GoWPlXuL24OY8zafG9+7yC07EUDlwJKREYCYfy21dhjnTqN
	09kkV3g0nvdaKCSneRZ/7yjkiFRbhy27L+evP+LNZXpzQV8F4xqPV6PXEyR
X-Google-Smtp-Source: AGHT+IHGr07uWJn+EN8WwafuZ1HRlOhGk+EnhZO9euTybAbZKnv2WX9MhnO40cJiUMNLBb7+jjE8lYwmoLnsY8D/ihM=
X-Received: by 2002:a17:902:c952:b0:295:62d:5004 with SMTP id
 d9443c01a7336-2984ed83897mr90210755ad.26.1763042213851; Thu, 13 Nov 2025
 05:56:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112195246.495313-2-slava@dubeyko.com> <CAOi1vP8swC=q1njp=EPYxkpAMv9cqmcysRNoPzRPpGwCzd3xrQ@mail.gmail.com>
 <fe20de6d968f0c6a2822e77c17545000683bd0f8.camel@ibm.com> <CAOi1vP_spJYpScu3=ZwZ7wR+if_cXB3k67yR35WFAUztYWX6Lg@mail.gmail.com>
In-Reply-To: <CAOi1vP_spJYpScu3=ZwZ7wR+if_cXB3k67yR35WFAUztYWX6Lg@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 13 Nov 2025 14:56:42 +0100
X-Gm-Features: AWmQ_blfxx7cYV-_9_hOWTHC2afjguf2vf1yEaIFZsZP2_SZIlCCLcjaWnKBUG4
Message-ID: <CAOi1vP-Za1ttOum5RmXOMA86vZauVLrnpv_qqytaDi3e1cSESw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix crash in process_v2_sparse_read() for
 fscrypt-encrypted directories
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "slava@dubeyko.com" <slava@dubeyko.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Patrick Donnelly <pdonnell@redhat.com>, 
	Alex Markuze <amarkuze@redhat.com>, Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 1:54=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> w=
rote:
> > What is the difference between data_length and sparse_read_total?
>
> In practice probably next to none, but sparse_read_total covers only
> CEPH_OSD_OP_SPARSE_READ extents so it's more on point.  There is some
> provision in the code for handling messages with more than one OSD op
> (e.g. a mix of regular and sparse reads).

Somehow a draft that I later edited got sent out as well.  Please
disregard this bit about mixing regular and sparse reads -- that may
have been the intent at some point but with the code as is it clearly
wouldn't work.

To avoid any confusion, here is what that paragraph was edited to:

> > What is the difference between data_length and sparse_read_total?
>
> In practice probably next to none, but sparse_read_total covers only
> CEPH_OSD_OP_SPARSE_READ extents so it would be more on point.

Thanks,

                Ilya

