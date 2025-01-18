Return-Path: <ceph-devel+bounces-2512-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C898CA15D3C
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Jan 2025 14:53:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48154188849E
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Jan 2025 13:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A407018CBF2;
	Sat, 18 Jan 2025 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Kc69DWY5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF3A2F50;
	Sat, 18 Jan 2025 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737208394; cv=none; b=qJrbSV+O9Gb3nur6Jjr786cbLifWPUbFosf3+AK9fUUFv1q+1McAJAmF/gH8JS7xnF40wEpVfuoQLNWnWtsBBrsoNf4/14ICXViqEkmf2OBPKsv2NYMt7ondj1BlxuLTXZ43nwbay+BkRohuV4QcgwrtMW2K8Xwc6eCkijwc0Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737208394; c=relaxed/simple;
	bh=ZnyNOwaPiDOb8UgezUN3RDOGYCQIj2OrMgtucTAln74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WHYggHZ9JRbSJirWiln6xCqvlFMhWpFZlz+iPtSwy8Z0xmMOLARXTd2GQieiqXYqddvRb2lCDiXV9UwBS3b+yJKqc7jIIQ+UIYng6F+HqEO82eBW0JoJbzbtAxVixQ7CeECjdDQkmwqjM9+zYczZUW4EGnLiXhpMCoeBh3l1jgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Kc69DWY5; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=0dwAW
	uXni0RHdliEtVE1GPnfPT4rxlY1U+4bKW4Xon0=; b=Kc69DWY5g8k+6ObbQDZJX
	WHfEouTIMzzF4U8qQDEoP+/wYshvZua/vjbcNLQeuPmxDV1VT6n+hwOxV3OiMEgn
	GRDmSwp6R/03i41xiAbIlrBuZj4BYLuzqgLNSKGdgcwz+UUVTPtbQxa5ixPfQ9aK
	pu0xOzQxm6iHwhgqSacu6Q=
Received: from hello.company.local (unknown [111.205.82.7])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD3n+4rsotnc4r5Kw--.56432S2;
	Sat, 18 Jan 2025 21:52:44 +0800 (CST)
From: Liang Jie <buaajxlj@163.com>
To: idryomov@gmail.com
Cc: Slava.Dubeyko@ibm.com,
	buaajxlj@163.com,
	ceph-devel@vger.kernel.org,
	fanggeng@lixiang.com,
	liangjie@lixiang.com,
	linux-kernel@vger.kernel.org,
	xiubli@redhat.com,
	yangchen11@lixiang.com
Subject: Re: [PATCH] ceph: streamline request head structures in MDS client
Date: Sat, 18 Jan 2025 21:52:43 +0800
Message-Id: <20250118135243.3560118-1-buaajxlj@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAOi1vP8vNjDpyqT8wd0AuEWfvMjn0r5tML=pMNbWYb=kATAaOg@mail.gmail.com>
References: <CAOi1vP8vNjDpyqT8wd0AuEWfvMjn0r5tML=pMNbWYb=kATAaOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD3n+4rsotnc4r5Kw--.56432S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGFW8urW5XryDZFy3WrWfXwb_yoWrAr4rpF
	WrGayayw4DJay3Grn2van2v34F9an3Cw1xJr4DtryrAF90k34xtay7KayF9Fy7WrWxCr1Y
	vF1jqF98Ww1jvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUI9akUUUUU=
X-CM-SenderInfo: pexdtyx0omqiywtou0bp/1tbiNgzYIGeLoCzZ5AAAsf

On Wed, 15 Jan 2025 21:15:11 +0100, Ilya Dryomov <idryomov@gmail.com> wrote:
> On Fri, Jan 10, 2025 at 8:25=E2=80=AFPM Viacheslav Dubeyko
> <Slava.Dubeyko@ibm.com> wrote:
> >
> > On Fri, 2025-01-10 at 18:05 +0800, Liang Jie wrote:
> > > From: Liang Jie <liangjie@lixiang.com>
> > >
> > > The existence of the ceph_mds_request_head_old structure in the MDS
> > > client
> > > code is no longer required due to improvements in handling different
> > > MDS
> > > request header versions. This patch removes the now redundant
> > > ceph_mds_request_head_old structure and replaces its usage with the
> > > flexible and extensible ceph_mds_request_head structure.
> > >
> > > Changes include:
> > > - Modification of find_legacy_request_head to directly cast the
> > > pointer to
> > >   ceph_mds_request_head_legacy without going through the old
> > > structure.
> > > - Update sizeof calculations in create_request_message to use
> > > offsetofend
> > >   for consistency and future-proofing, rather than referencing the
> > > old
> > >   structure.
> > > - Use of the structured ceph_mds_request_head directly instead of the
> > > old
> > >   one.
> > >
> > > Additionally, this consolidation normalizes the handling of
> > > request_head_version v1 to align with versions v2 and v3, leading to
> > > a
> > > more consistent and maintainable codebase.
> > >
> > > These changes simplify the codebase and reduce potential confusion
> > > stemming
> > > from the existence of an obsolete structure.
> > >
> > > Signed-off-by: Liang Jie <liangjie@lixiang.com>
> > > ---
> > >  fs/ceph/mds_client.c         | 16 ++++++++--------
> > >  include/linux/ceph/ceph_fs.h | 14 --------------
> > >  2 files changed, 8 insertions(+), 22 deletions(-)
> > >
> >
> > Looks good to me. Nice cleanup.
> >
> > Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> 
> Applied.
> 
> Thanks,
> 
>                 Ilya

Hi Ilya,

I have recently received a warning from the kernel test robot about an indentation
issue adjacent to the changes made in my this patch.

The warning is as follows:
(link: https://lore.kernel.org/oe-kbuild-all/202501172005.IoKVy2Op-lkp@intel.com/)

> New smatch warnings:
> fs/ceph/mds_client.c:3298 __prepare_send_request() warn: inconsistent indenting
> 
> vim +3298 fs/ceph/mds_client.c
> 
> 2f2dc053404feb Sage Weil      2009-10-06  3272  
> ...
> ce0d5bd3a6c176 Xiubo Li       2023-07-25  3295  	if (req->r_attempts) {
> 164b631927701b Liang Jie      2025-01-10  3296  		old_max_retry = sizeof_field(struct ceph_mds_request_head,
> ce0d5bd3a6c176 Xiubo Li       2023-07-25  3297  					    num_retry);
> ce0d5bd3a6c176 Xiubo Li       2023-07-25 @3298  	       old_max_retry = 1 << (old_max_retry * BITS_PER_BYTE);
> ce0d5bd3a6c176 Xiubo Li       2023-07-25  3299  	       if ((old_version && req->r_attempts >= old_max_retry) ||
> ce0d5bd3a6c176 Xiubo Li       2023-07-25  3300  		   ((uint32_t)req->r_attempts >= U32_MAX)) {
> 38d46409c4639a Xiubo Li       2023-06-12  3301  			pr_warn_ratelimited_client(cl, "request tid %llu seq overflow\n",
> 38d46409c4639a Xiubo Li       2023-06-12  3302  						   req->r_tid);
> 546a5d6122faae Xiubo Li       2022-03-30  3303  			return -EMULTIHOP;
> 546a5d6122faae Xiubo Li       2022-03-30  3304  	       }
> ce0d5bd3a6c176 Xiubo Li       2023-07-25  3305  	}

The warning indicates suspect code indent on line 3298, existing before my
proposed changes were made. After investigating the issue, it has become clear
that the warning stems from a pre-existing code block that uses 15 spaces for
indentation instead of conforming to the standard 16-space (two tabs) indentation.

I am writing to seek your advice on how best to proceed. Would you recommend that
I adjust the indentation within the scope of my current patch, or would it be more
appropriate to address this as a separate style fix, given that the indentation
issue is not directly introduced by my changes?

I am happy to make the necessary adjustments to ensure the code base adheres to the
kernel's coding standards. However, I also want to respect the best practices of
contributing to the project and maintain the clarity and focus of my patch.

Kindly advise on the preferred way forward.

Thank you for your time and guidance.

Best regards,
Liang Jie


