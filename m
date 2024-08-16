Return-Path: <ceph-devel+bounces-1692-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 363AC9542CD
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Aug 2024 09:34:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B77332853BB
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Aug 2024 07:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C747E0FF;
	Fri, 16 Aug 2024 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHnL4kf0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A131F76056;
	Fri, 16 Aug 2024 07:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723793682; cv=none; b=pw8DBGYveOucYtq5cAPJGnM0oPk/rNii+Py8XlJuK7HW38Lbs2yIeUvAh97R0OHT0m7mKP+i7jykHFs0b18MRiiIWLW4byOwKyIYdcYotzFFc/dq8G9OHOUYsXWWQzETRpDT7EmjUokjQ4EWLH6exP0vjnIUfWWHfMNsgzxK97A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723793682; c=relaxed/simple;
	bh=nnyYYh/iyb9sGXw7mInNjvZMUZLdh3n2Y0wdyaMuEd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fH7CNfSICv4P6bo+bSl5sYjeIJnz5zHuIYSyaUUQpb0mXCJJ1QcqksHBOZjsz1IcEgMjUWhfZBHAL+5otxNWdXAtIKvY4ZUV4DQUf37G2dGOL3dcxN6HO390Zi4FzEnOTxEn1OJtYx/WaBeiIFneNrjX+QVR0xkOk6QQlMcz36s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHnL4kf0; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-26ff21d8382so1225420fac.1;
        Fri, 16 Aug 2024 00:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723793679; x=1724398479; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6A1abrd8F2BkjqsMfwBx1yo38CYby9aZLUmCJJXibuk=;
        b=UHnL4kf0XZGp4EI/PAW8IdiZ6DpO90WKRzGzxpsZcxeHYIKH+rdQII4tw5FE47Kr36
         aztjL7M9dCimBrL4BgUstccIB81uu9G4CygFwvo2/5o87k8hdy66aORbk8T8qbazoXn2
         tGpGYcI1qSoC5rYIMQB8LvLBPLhnjCRSRw6rXWapBUHyjEjpK6LEQL/VOXbn1a5GYAkj
         k3FJCbZSm6VM2aYu2iHXH6LJDnkGuNarExmZvTVb7L9HqekwsJ7IkaUV0wjyfBJiB/8n
         8q9xUsAFNT3b3vqBk8kKgAVK/uWjDErw8KKtLmt99HHXAkv3VfYk7pmXfcT1akXLLOLO
         q21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723793679; x=1724398479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6A1abrd8F2BkjqsMfwBx1yo38CYby9aZLUmCJJXibuk=;
        b=N6GBCYCk9C3SWaBWVPAezHcKXMxG/57VkqcIRixdOGOR83mzOOW7ulC7iNa9FNlI23
         UJvhIpDh60HkXXtVyH0SLkP72Rr1HEhVoJwVr8nZtlnywPO9W+83jlvjorcACvc3C2Cr
         JDvCyXo9DjLalOMbx+M1MsVZoo1G7tJcHvi5SSGrVBvwqW1aQYFUD8Gl/4SIhg3JQWv3
         1lVDagVeD0c3kE4dj0T2vWUYd+PyMTm5I+540QfssoBG2Xca6HIYLuzJZxzyhpXliplz
         BrSBN2jOeVZlH/QDU8pr+wQFsjhtxMXTcImIfoJ/uKJB/i95sZwKktMRqvb3DBVydisQ
         es0A==
X-Forwarded-Encrypted: i=1; AJvYcCUoPmsX2UDgLvWjHAzZ5PNPB2ibur7YAnP9+3AhgNR1fZftuqGPsNXjW/Kf7024CwLlq/KHMimkbTX1lBFQDaFHPAaswrUzx6B1QiYAqfkX34VTbSj/guAl6E92fwqP+uJ6Z9AagPlKZA==
X-Gm-Message-State: AOJu0Yx2VGHLoOo7x2jxjP+n/xmVFj3vTGlI7inGotjn08jBmL/UNMcc
	c5++8eWxs+0slPOw/d4P74zqQ/upauhRPbIKrtZ0PZHOUjdbMkyn+NOharmiflhlOclNm+3Mgh7
	UbCptWsxL4eKFNC4kT24rsXomdxA=
X-Google-Smtp-Source: AGHT+IErkm8a3ZmVpZeSRHvMjsFrb31XkxJm3L+puP10f+nfzp4cF7Jg8YzIHHZBOX+OUh/x+baczAOAXeaRrnNLgHk=
X-Received: by 2002:a05:6871:611:b0:270:1fc6:18 with SMTP id
 586e51a60fabf-2701fc610c2mr1829067fac.3.1723793679657; Fri, 16 Aug 2024
 00:34:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814033415.3800889-1-yuehaibing@huawei.com> <12c6204822cbff71338d0e2bab2f90d155b3cb63.camel@kernel.org>
In-Reply-To: <12c6204822cbff71338d0e2bab2f90d155b3cb63.camel@kernel.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 16 Aug 2024 09:34:00 +0200
Message-ID: <CAOi1vP8Pritbc3YTKAtCRKc1fviKtzau6FH=-LvpOKq3L4Mqbw@mail.gmail.com>
Subject: Re: [PATCH -next] ceph: Remove unused declarations
To: Jeff Layton <jlayton@kernel.org>
Cc: Yue Haibing <yuehaibing@huawei.com>, xiubli@redhat.com, mchangir@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 1:56=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Wed, 2024-08-14 at 11:34 +0800, Yue Haibing wrote:
> > These functions is never implemented and used.
> >
> > Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> > ---
> >  fs/ceph/mds_client.h            | 3 ---
> >  fs/ceph/super.h                 | 2 --
> >  include/linux/ceph/osd_client.h | 2 --
> >  3 files changed, 7 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > index 9bcc7f181bfe..585ab5a6d87d 100644
> > --- a/fs/ceph/mds_client.h
> > +++ b/fs/ceph/mds_client.h
> > @@ -559,9 +559,6 @@ extern struct ceph_mds_session *
> >  ceph_get_mds_session(struct ceph_mds_session *s);
> >  extern void ceph_put_mds_session(struct ceph_mds_session *s);
> >
> > -extern int ceph_send_msg_mds(struct ceph_mds_client *mdsc,
> > -                          struct ceph_msg *msg, int mds);
> > -
> >  extern int ceph_mdsc_init(struct ceph_fs_client *fsc);
> >  extern void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc);
> >  extern void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc);
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 6e817bf1337c..c88bf53f68e9 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -1056,8 +1056,6 @@ extern int ceph_fill_trace(struct super_block *sb=
,
> >  extern int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> >                                   struct ceph_mds_session *session);
> >
> > -extern int ceph_inode_holds_cap(struct inode *inode, int mask);
> > -
> >  extern bool ceph_inode_set_size(struct inode *inode, loff_t size);
> >  extern void __ceph_do_pending_vmtruncate(struct inode *inode);
> >
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_c=
lient.h
> > index f66f6aac74f6..d7941478158c 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -449,8 +449,6 @@ extern int ceph_osdc_init(struct ceph_osd_client *o=
sdc,
> >  extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
> >  extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
> >
> > -extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
> > -                                struct ceph_msg *msg);
> >  extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
> >                                struct ceph_msg *msg);
> >  void ceph_osdc_update_epoch_barrier(struct ceph_osd_client *osdc, u32 =
eb);
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Applied.

Thanks,

                Ilya

