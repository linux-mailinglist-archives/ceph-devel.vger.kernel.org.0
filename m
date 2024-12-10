Return-Path: <ceph-devel+bounces-2282-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 563F39EAAE0
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2024 09:43:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 210CA188AFBE
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2024 08:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84585230D04;
	Tue, 10 Dec 2024 08:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZKvoZl5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E152309A9;
	Tue, 10 Dec 2024 08:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733820170; cv=none; b=DVB0OOr0pmdQmm1XdlAvpVtmqARWeEPncpL7kqif/ssyTT6TZlyjhapZ1Qw2LoAwizODba+I5WrOmDqtKJXZEtFfs3fqdrui6RDM3LVB3nrNfN1z69pF4JBRyI8VBLuQEEwXJ2xV48HLbPK5yRJOk1X1JrL0OFRCk/tCeAbMmm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733820170; c=relaxed/simple;
	bh=jQk0f4q/XuuCz0zjldQlJAbtGrGdqrsZPT5uFwBjoaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ko4xtIRPqAip8LrJF6gu6K4p759Nezrj24xyGUBqhj9t6JCXCGdTenR3nCVJHTwEK+wDVgGdKJ4MwTsWkOq7hWuCSAp5hM6MbO7vu0CG6km9dDVStgqND1Ztm2/Rb366rt61xmlst8vZbRhtQSnHLqMfrP0T0yo1XXV4L5utyCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HZKvoZl5; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7feb6871730so414090a12.2;
        Tue, 10 Dec 2024 00:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733820168; x=1734424968; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTrCgQ6oD+C4Q1a4tXHCQ84NTz2H34kW2g7zBT5Aiqw=;
        b=HZKvoZl56dAKmj425WXN5WiIhYTWqtvin31G4elEKEOf/1ORVq7u6Bcju9Q1rYujGi
         4BtKg8xU1A6ShCcdSPFy82w9/l6umTYUve6Sp6Xq8jByKEFfthCgUF7jJ6HznVeBWV+E
         B4ziNr/1et+ROi6DTVge7y0qwQmInQIO0TyLzf6nNcdRISXxXbbAKnmqYO6KTwTd8c6R
         GYvgnsIODhVFixboAxv95d7h4Kpk4rmJ8CKKCKckegmthPyze21rnYyGmjy6eUjQEyfO
         P32lyyKdWRgVwUb42NB8WojvX/ks6i5Fd9TuM8nYcktFS9DlyUwfEkkwm/9x7haiO4Nx
         M7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733820168; x=1734424968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTrCgQ6oD+C4Q1a4tXHCQ84NTz2H34kW2g7zBT5Aiqw=;
        b=JWd/XAHyUCzyNldISJHUp16bNlFpvq0UY+qDTSm17LvrsRywFsjhk+H8UHNDyyhEZc
         +/vUI1pH8aMfUz+hK+kwlZ43OjPR5mWv0Q2zIAxMiuGNKM3kXKA1qbGsvHaukP3VZ8El
         52BEKh85LlBTeOMkwHfZBT/I/ZcN27Rnr0D/dvzkyRJOoRHtJYI0EzOR8rEQaSL2d0MI
         D/dTgR3wbS9F0irXCFPtsLUYsiVG5kYUVo/rmab9onE5u6DwvzvC7eknYweu+XZ+5TKQ
         hJMmAp/yzljb7PDI0NprtZTxcgW6xjf/l3QdHtSZ+2WOWnHk6D1j0REvuwn3j9AuxyMb
         m0nw==
X-Forwarded-Encrypted: i=1; AJvYcCVOodw+u6knftMGy/BcNIWA/9OjVKlij+yMtj+g29YRHCThn7vgo7CcSagujs7mcyQGS+UhldjWI+d5@vger.kernel.org, AJvYcCWj/nvYKNNMU6GawW5/MYIf7ssUsjK4a+/KlAK2oDxjmcSFYdXgZ/WA23VWOfpOIJFW+lOzoV0V@vger.kernel.org, AJvYcCXdhcqIDSkX2TqfJLMgbhKJUAOez/8w2pbHqzHSPZQYNJ1vowXc53JDtVpGFWZ27y85jeHBGj6KI4bgRmOl@vger.kernel.org
X-Gm-Message-State: AOJu0YyqoWZakONCK6Nw5Z0rky3vay/RgnZszXdi94GCBjIW05pJqLVa
	Jrk8b41igzmlqqXJh4pkVKI0zB0zLq+B9Gi3JpganP7+m8FxdAoMhuwxwcWLbj/L9NpREwxpHct
	fiuOxfWyNdVG34omLPFETklbd0t0JpzjL
X-Gm-Gg: ASbGncsu+1pDtLBBtAVEeRwBZa2Vbq3kt/c6kcR7xtchAjWPlsQ3I7v442aFgWjb4kb
	DQrTnhaU1oEBZAvu3d9UeUasf4mi3+o4XDpE=
X-Google-Smtp-Source: AGHT+IEIrGB+h3xUiEFf08eWa/unQdF5bHd02QOFRJlA54LZ44ereWwVqvK9NYKA6FonW/Oa8uGHFGM1dzqdsog370k=
X-Received: by 2002:a17:90b:4c07:b0:2ee:5111:a54b with SMTP id
 98e67ed59e1d1-2efcf26daddmr4636315a91.31.1733820168089; Tue, 10 Dec 2024
 00:42:48 -0800 (PST)
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
 <CAKPOu+8u1Piy9KVvo+ioL93i2MskOvSTn5qqMV14V6SGRuMpOw@mail.gmail.com>
 <CAO8a2SizOPGE6z0g3qFV4E_+km_fxNx8k--9wiZ4hUG8_XE_6A@mail.gmail.com>
 <CAKPOu+_-RdM59URnGWp9x+Htzg5xHqUW9djFYi8msvDYwdGxyw@mail.gmail.com>
 <CAO8a2ShGd+jnLbLocJQv9ETD8JHVgvVezXDC60DewPneW48u5A@mail.gmail.com>
 <CAKPOu+-d=hYUYt-Xd8VpudfvMNHCSmzhSeMrGnk+YQL6WBh95w@mail.gmail.com> <CAO8a2ShQHCRWBGWs4rk69Gvm-NoKHyZPKJmmsazKeY3UZHeEdw@mail.gmail.com>
In-Reply-To: <CAO8a2ShQHCRWBGWs4rk69Gvm-NoKHyZPKJmmsazKeY3UZHeEdw@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 10 Dec 2024 09:42:36 +0100
Message-ID: <CAOi1vP-y26UPWH1Wv+Fb4c_cBc-59uxTJ=i5FuAHugPvrFaeXw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Alex Markuze <amarkuze@redhat.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 8, 2024 at 11:17=E2=80=AFAM Alex Markuze <amarkuze@redhat.com> =
wrote:
>
> Illya, this patch is tested and it has my review by.

Max's original patch has been applied (with the authorship, commit
message, etc preserved).

Thanks,

                Ilya

>
> On Thu, Dec 5, 2024 at 10:24=E2=80=AFAM Max Kellermann <max.kellermann@io=
nos.com> wrote:
> >
> > On Wed, Dec 4, 2024 at 1:51=E2=80=AFPM Alex Markuze <amarkuze@redhat.co=
m> wrote:
> > > It's already in a testing branch; what branch are you working on?
> >
> > I found this on branch "wip-shirnk-crash":
> > https://github.com/ceph/ceph-client/commit/6cdec9f931e38980eb007d9704c5=
a24535fb5ec5
> > - did you mean this branch?
> >
> > This is my patch; but you removed the commit message, removed the
> > explanation I wrote from the code comment, left the (useless and
> > confusing) log message in, and then claimed authorship for my work.
> >
>

