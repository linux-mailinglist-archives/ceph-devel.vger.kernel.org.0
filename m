Return-Path: <ceph-devel+bounces-3831-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A82BCDE19
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Oct 2025 17:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9AC9D4FF8ED
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Oct 2025 15:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3161E26B759;
	Fri, 10 Oct 2025 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCdjm0MC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0365125DAF0
	for <ceph-devel@vger.kernel.org>; Fri, 10 Oct 2025 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760111483; cv=none; b=QvFOBtUYcynnyMogfqdP9D9Pp0mSvk07HpwKb4SwY293pNP3/wtT6xjMWA+CQf4eMrwTITzIywYGGuyLQVqPRRFCFWhcRwY+6RJWNnedoQQhKLj5pdQUXs3iONDmqYNET+IrGvY9MdjVazQ7uwE2ritMnFAgfwkW9X64i3USe7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760111483; c=relaxed/simple;
	bh=TfNKgAwty2Qn00bV61R/qulEyPoJyzCS7e1xQ1v/Tp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YcH/EHHezdJ+DhP+2QdVCT4sm5nYbvep79rEzBqB2XV+hZdGoBEB5uwos1echYmQ3u+2e3eB9vYPOiv0ohBydMTqe3KCPqDK7E4PxbgOswpOrTL12IE6+4iUREP8WV8NLkSkKoLOa+pjek5oT3UjFtkcEBIBi0PPzc3dGRwMNH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lCdjm0MC; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62fb48315ddso3238256a12.2
        for <ceph-devel@vger.kernel.org>; Fri, 10 Oct 2025 08:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760111479; x=1760716279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhH9vWsw8gK9Ns25kQJ5DC4FK/KR5dBSJxG+yxQ1Djk=;
        b=lCdjm0MCSicT5ohXLnU+1eU4uosnNbe3+T930M/f4sRMs2RHwMBqyjq3JzzRNMWFR1
         YHE3JeLz3P9jHjdJDIFZLsiScLvsce9q/63KnWKHkCfk7q5TIcB+/L0eJj3rk/gImSbx
         pKFVSaAyaCSCADkovW4YdjlSMjy22Tt0ZL2XfXyVSOY4PrbXsWupmRfq2Eoqvwnm5AEq
         AVEISQm1IMYjazjS3gaooCgRRgSqUcG5PV3Ou2x4Y4oDa6jJz6vjRyY22WGBLbUnZpvO
         4SH17Y/s+f7LQ9a066xc0BoGU/eYBsxJGnRWscpcBKcpH/kLcPftsFMSZ2trN3dHjKzi
         oPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760111479; x=1760716279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UhH9vWsw8gK9Ns25kQJ5DC4FK/KR5dBSJxG+yxQ1Djk=;
        b=H2F1vYOZ2w+oyACSlxi9xuOLAysrRKt+PJg3jguH+Ea3TYPhyIflxw/WcLUdVimblB
         4pARNnQ1YfEjpF2FJgnXW/fLP8beCBXjtaUFfdq8gPigStIEmVx+K5Hppjr3Z7KzRen6
         zRzEIU8x+vxexdyxEWC/lS4K5/qvTTyL6cE71AH/a/fkHiwYUEP+hAbQa1U6cOBKmupl
         aibgCcKHzG9grS2tIgbx2tpDrnDJR1kJaFqTqeX5uQkxHfYW4jM9CWnbgG3jBs0qPYX3
         O64nNbp4WlUEWq8WWUsky2Ls63JpdoZ480tUK3QsIpFrwgDptU5i7w95suslr1PE1Wk3
         0RtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR6k1DFolhBOv5zMY3R+LFo/+TZ8Yi5J8gpWbLJ/SBVa+n30P0oM+lMyy2e/KDusOVXPSxYVUTk35w@vger.kernel.org
X-Gm-Message-State: AOJu0YyFmiQz1TfHFW1hmEF7caOPEa3rpwj8BRQKqMMBdDeSC3q6mRGD
	nTdngix1NiHBZnx2CFQ6YpWNMBzUTzydhXRdQdmJ0T4YaYNgIj7U+kpiANGcnEzoLyN6MTeHUxS
	o5NsxtZl2fh2CJGicK7JjdGNKgkUQXmI=
X-Gm-Gg: ASbGncsGFIlwgx0CfUMNqnjTwtj0INyVRoDBNB8LzHRHKV6tnNMeB91L9dwaLCQK614
	2St4Rb7OkJo4K4iGVVwwIsTGCqrWKQpuJGoLTHRtzKxnAGdLqc/OGzzxeah4RpZtYuaMZfup1v3
	LxSY9HUzExDb9u3EOLudA09CX4lEp6zGokgtQtPdIopHiDI8mY7hKer9rSqv22E2nAw4CqWtI+F
	wkGkMG1Dsvz35mN9OLOrpUsIjdIJ3+WvTF9XNFEJEez97tKdBR96QApAAZEfZMDNzXG
X-Google-Smtp-Source: AGHT+IE+fpwB+bY36jZhuFvtAiR+1ExrpMDWYUETjZUPwkwAWYTKotWAPrtOsHK68GTsCIaCtcLyUWD8+YiMIbEIYPI=
X-Received: by 2002:a17:907:3daa:b0:b4a:d0cf:8748 with SMTP id
 a640c23a62f3a-b50a9a6d769mr1349543366b.13.1760111478957; Fri, 10 Oct 2025
 08:51:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009075929.1203950-1-mjguzik@gmail.com> <20251009075929.1203950-4-mjguzik@gmail.com>
 <h2etb4acmmlmcvvfyh2zbwgy7bd4xeuqqyciqjw6k5zd3thmzq@vwhxpsoauli7>
In-Reply-To: <h2etb4acmmlmcvvfyh2zbwgy7bd4xeuqqyciqjw6k5zd3thmzq@vwhxpsoauli7>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 10 Oct 2025 17:51:06 +0200
X-Gm-Features: AS18NWAdR8mn7h75Ldgul-s1iHW_YrjMNEOV1VnI-B-ScP1aM5_q24GjzqXvcko
Message-ID: <CAGudoHFJxFOj=cbxcjmMtkzXCagg4vgfmexTG1e_Fo1M=QXt-g@mail.gmail.com>
Subject: Re: [PATCH v7 03/14] fs: provide accessors for ->i_state
To: Jan Kara <jack@suse.cz>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2025 at 4:44=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 09-10-25 09:59:17, Mateusz Guzik wrote:
> > +static inline void inode_state_set_raw(struct inode *inode,
> > +                                    enum inode_state_flags_enum flags)
> > +{
> > +     WRITE_ONCE(inode->i_state, inode->i_state | flags);
> > +}
>
> I think this shouldn't really exist as it is dangerous to use and if we
> deal with XFS, nobody will actually need this function.
>

That's not strictly true, unless you mean code outside of fs/inode.c

First, something is still needed to clear out the state in
inode_init_always_gfp().

Afterwards there are few spots which further modify it without the
spinlock held (for example see insert_inode_locked4()).

My take on the situation is that the current I_NEW et al handling is
crap and the inode hash api is also crap.

For starters freshly allocated inodes should not be starting with 0,
but with I_NEW.

I can agree after the dust settles there should be no _raw thing for
filesystems to use, but getting there is beyond the scope of this
patchset.

> > +static inline void inode_state_set(struct inode *inode,
> > +                                enum inode_state_flags_enum flags)
> > +{
> > +     lockdep_assert_held(&inode->i_lock);
> > +     inode_state_set_raw(inode, flags);
> > +}
> > +
> > +static inline void inode_state_clear_raw(struct inode *inode,
> > +                                      enum inode_state_flags_enum flag=
s)
> > +{
> > +     WRITE_ONCE(inode->i_state, inode->i_state & ~flags);
> > +}
>
> Ditto here.
>
> > +static inline void inode_state_clear(struct inode *inode,
> > +                                  enum inode_state_flags_enum flags)
> > +{
> > +     lockdep_assert_held(&inode->i_lock);
> > +     inode_state_clear_raw(inode, flags);
> > +}
> > +
> > +static inline void inode_state_assign_raw(struct inode *inode,
> > +                                       enum inode_state_flags_enum fla=
gs)
> > +{
> > +     WRITE_ONCE(inode->i_state, flags);
> > +}
> > +
> > +static inline void inode_state_assign(struct inode *inode,
> > +                                   enum inode_state_flags_enum flags)
> > +{
> > +     lockdep_assert_held(&inode->i_lock);
> > +     inode_state_assign_raw(inode, flags);
> > +}
> > +
> > +static inline void inode_state_replace_raw(struct inode *inode,
> > +                                        enum inode_state_flags_enum cl=
earflags,
> > +                                        enum inode_state_flags_enum se=
tflags)
> > +{
> > +     enum inode_state_flags_enum flags;
> > +     flags =3D inode->i_state;
> > +     flags &=3D ~clearflags;
> > +     flags |=3D setflags;
> > +     inode_state_assign_raw(inode, flags);
> > +}
>
> Nobody needs this so I'd just provide inode_state_replace().
>

The unused _raw variants are provided for consistency for the time
being. I do expect some of them to die later.

