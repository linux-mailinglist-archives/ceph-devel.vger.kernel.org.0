Return-Path: <ceph-devel+bounces-2454-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA89A12C57
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 21:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 575BB165E24
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 20:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B3C1D5CCD;
	Wed, 15 Jan 2025 20:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEBD5o1I"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811A978F3B;
	Wed, 15 Jan 2025 20:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736972126; cv=none; b=J3nsLGJqKIM82nHNekPuJqrSJV4m4JEP4L4CMiJ7fs/4qBHS3hqE3w/Dssp8v4l4yq0oqccrWC+T9J9oTRMiWqiNDozRrYZxUsPsMC+kpQ0w9TFF93ZJX+kv1N+yKvc8gNeRyeotBrj+5K7anOY0rbIZyjLFdOuUMC9BUVWUAHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736972126; c=relaxed/simple;
	bh=5Hf/nLkJZrbkfPffy3rPRnNp0p4VRBaNKH7PNhTiQxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LAtBdGSp6w1qMPHmFMZwuZYILi2fQxa5VbrOra7iGYQ6zXu1oWfmkuTKdT2Xdx5GnYZOitugoLRUtQh01e8pjdnrM0JRgbUcgWspTM1xngF9eI4NfM5btfvkNhupxW8W8hOr5J4ugK6CEdvg5uxEd/L6dmXVa2GfgAWb3eiG/B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TEBD5o1I; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ee9a780de4so291089a91.3;
        Wed, 15 Jan 2025 12:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736972124; x=1737576924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3wZZiLl1Wrfpem6Tx+w58FRFisn7HnyJBP0dT68J3d8=;
        b=TEBD5o1ITRTXZpoDGDjFMFCeYVMQU9T21fEDDgugRktO7kIsVJMfzy3kH5YJIyDkzw
         kp99JiA4aDHdTeN3T6qQaFNFktPY1sAWlTAhtK+qUC0/Kzaw2fShcMD5RRuNOAvKyrLc
         LmVL8zjs1qk+OMViJXYtarKA7mKf44ylltXVyRGkAQrUYHDC+cT8MZpTM0io0d5oLWZD
         LRtMogouurji0DVholL8KK86Wk8oIiMBuM465H4VF9sMMgrYlFbtcr1P6U1y6w+nj6+Z
         rRDrIj7XKO/dJ3T2h4A86TQQraV3wn3BGq2Z/gBhNyehM7lIwxUNtNZBQqB/EOffCwDi
         +xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736972124; x=1737576924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3wZZiLl1Wrfpem6Tx+w58FRFisn7HnyJBP0dT68J3d8=;
        b=wra/156+yqQ7S1WqhidJ4J0k+3DlWG8JyGEkrtzJxtr8jbQe6MyxEsF0Z5k69DOlz+
         RXsNGza577y3d+t1h/LQGRvPnWYxf1ul0gVr451+rSVojN9KRlgGgojvRIZuVbodXnf0
         2DnDzdsRkAXag/C1X1+pInkBXc1iYHhOrC5UJCl2upepFUzSJ8dScpyN/Sb0aoxTMUqL
         FEf8LMDPySeWQBCmPwY1vyLt4hOrA/SnJfiaUc0Md/0yeBH1cvN8mvj6jgcw4u4wnM2b
         FCYF/wFUKfrLkNyXXdzNfX/jkpTndv7b6I3nUge8ZHTZlQyzryDgTribn4Ufs4cV0rXL
         YhEQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0lOfs8rLM3hKeoDhEBfAWt/lhexPGwNTzYXapO9atPYXSzrPMSBxw1oDvpMndx1NDzCbf9y9tnxbj@vger.kernel.org, AJvYcCV3cdmhKIyohBrjG5Orm5sZijKNnZyY7G1PDnrrLNCWUIWmyHWi0o2e7g0Y9ENXSFD3LfqFFull8m0Ndx6f@vger.kernel.org
X-Gm-Message-State: AOJu0YyCJUFYqQwIjqeHUKO+/dxXFZ6CH7Cpq02JXAv+Jxfejjb8XOcW
	MZi/Z367W5RHnbcWqTs6nhQKGC9JHSzQV72D4hHc6HXT90pPxWezBcA8MhXEVfcIK9NrHz2/shu
	a/v1/LOCQXHOPCgVOf6SywKbWV3kfPO3j
X-Gm-Gg: ASbGncuFiBidLUXSQ8JOh25URW9B43F7dlkWfLiU/LOe6xK7EFD4+LmWVD191QsOb7c
	uY863xtUfwzfI2n2NanWQfuSqiaQ/OOaZsUKvFw==
X-Google-Smtp-Source: AGHT+IEL4lz5LPM5A37ZAQ3Zmitf03Fgf6VNFyCWsXZU4pIzwCT9RFgUeQ3TFUgxzUCn/w6zUJ0X23uRGt7axHDxpw8=
X-Received: by 2002:a17:90b:50c4:b0:2ee:d7d3:3019 with SMTP id
 98e67ed59e1d1-2f548ebf4fbmr51995001a91.12.1736972123636; Wed, 15 Jan 2025
 12:15:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250110100524.1891669-1-buaajxlj@163.com> <c5276b40b56a092ea1ec8d161eaa42926018bf5f.camel@ibm.com>
In-Reply-To: <c5276b40b56a092ea1ec8d161eaa42926018bf5f.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 15 Jan 2025 21:15:11 +0100
X-Gm-Features: AbW1kvbqNK6fD142AoIG7tcreSIXyeXqwWcLfEjx45Q0Jn33dGAMXGJdvrkZ1Z0
Message-ID: <CAOi1vP8vNjDpyqT8wd0AuEWfvMjn0r5tML=pMNbWYb=kATAaOg@mail.gmail.com>
Subject: Re: [PATCH] ceph: streamline request head structures in MDS client
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "buaajxlj@163.com" <buaajxlj@163.com>, 
	"fanggeng@lixiang.com" <fanggeng@lixiang.com>, "yangchen11@lixiang.com" <yangchen11@lixiang.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"liangjie@lixiang.com" <liangjie@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 8:25=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Fri, 2025-01-10 at 18:05 +0800, Liang Jie wrote:
> > From: Liang Jie <liangjie@lixiang.com>
> >
> > The existence of the ceph_mds_request_head_old structure in the MDS
> > client
> > code is no longer required due to improvements in handling different
> > MDS
> > request header versions. This patch removes the now redundant
> > ceph_mds_request_head_old structure and replaces its usage with the
> > flexible and extensible ceph_mds_request_head structure.
> >
> > Changes include:
> > - Modification of find_legacy_request_head to directly cast the
> > pointer to
> >   ceph_mds_request_head_legacy without going through the old
> > structure.
> > - Update sizeof calculations in create_request_message to use
> > offsetofend
> >   for consistency and future-proofing, rather than referencing the
> > old
> >   structure.
> > - Use of the structured ceph_mds_request_head directly instead of the
> > old
> >   one.
> >
> > Additionally, this consolidation normalizes the handling of
> > request_head_version v1 to align with versions v2 and v3, leading to
> > a
> > more consistent and maintainable codebase.
> >
> > These changes simplify the codebase and reduce potential confusion
> > stemming
> > from the existence of an obsolete structure.
> >
> > Signed-off-by: Liang Jie <liangjie@lixiang.com>
> > ---
> >  fs/ceph/mds_client.c         | 16 ++++++++--------
> >  include/linux/ceph/ceph_fs.h | 14 --------------
> >  2 files changed, 8 insertions(+), 22 deletions(-)
> >
>
> Looks good to me. Nice cleanup.
>
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Applied.

Thanks,

                Ilya

