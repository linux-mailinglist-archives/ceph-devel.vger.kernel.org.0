Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D8A376513
	for <lists+ceph-devel@lfdr.de>; Fri,  7 May 2021 14:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbhEGM0j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 May 2021 08:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233468AbhEGM0i (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 May 2021 08:26:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 070056144F;
        Fri,  7 May 2021 12:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620390338;
        bh=KuVLhEfV0ciN/BcCKW+Oyow/J6rlhH733GXNmUgWCio=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r6fXq83TVESWco0XzXwtE1O8JQlHpg2HQdMYMqc6IQqYnhgXg8qNAoj1AjQI/cwJr
         nHUxUYJVOwkmk8iuP8CTU6CNOsexeH/PX4rtbtw0ima1eJ6SaqhnPf/wZnKwEfxzWe
         iT6Eei8emZJx9kZah3YEEhWEcXMGkTWhN53VWXjkJFjWl091e8cU3vJiW0LtM3PV++
         9Tu8MwV4Rvh6sCGSOEpt7ZnHf9Y+2H6fXFfrGRvZQkWhxT2eFYbbPJfsc5PXiUZy5j
         kl872pIG1xqSWg/PZFO3o9chP+khHxWGKWgc9Xhtq5Cdn3nXFy2e2pXev1MNLqZIvV
         vt9PYpGYnc+FA==
Message-ID: <0064b4356a556c52c6d6dcf685fc837275ad55b3.camel@kernel.org>
Subject: Re: [GIT PULL] Ceph updates for 5.13-rc1
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 07 May 2021 08:25:36 -0400
In-Reply-To: <CAOi1vP-iB1vjemw_WsRFEycdm94B8Trg73sPWAxUt+1ZAzPkzg@mail.gmail.com>
References: <20210506143312.22281-1-idryomov@gmail.com>
         <CAHk-=wgjQgUYrMD_tTm5M1BqeN5Z7h_z5EkU65RXAnEevsTDLA@mail.gmail.com>
         <CAOi1vP-iB1vjemw_WsRFEycdm94B8Trg73sPWAxUt+1ZAzPkzg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-05-07 at 11:03 +0200, Ilya Dryomov wrote:
> On Thu, May 6, 2021 at 7:51 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > 
> > On Thu, May 6, 2021 at 7:33 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > 
> > > There is a merge conflict in fs/ceph/dir.c because Jeff's inode
> > > type handling patch went through the vfs tree together with Al's
> > > inode_wrong_type() helper.  for-linus-merged has the resolution.
> > 
> > Actually, the linux-next resolution looks wrong - or at least
> > unnecessary - to me.
> > 
> > The conversion to d_splice_alias() means that the IS_ERR() test is now
> > pointless, because d_splice_alias() handles an error-pointer natively,
> > and just returns the error back with ERR_CAST().
> > 
> > So the proper resolution seems to be to just drop the IS_ERR().
> > 
> > Adding Jeff and Al just as a heads-up.
> 
> I did it mechanically and then cross-checked against Jeff's patch:
> 
> https://lore.kernel.org/ceph-devel/20210316203919.102346-1-jlayton@kernel.org/T/#u
> 
> I guess neither Jeff nor I noticed that ERR_CAST() is redundant
> because previously ceph_get_snapdir() didn't have any error handling
> and the explicit check (which Jeff added in another patch that went
> through Al's tree) felt "precious".
> 

Yep, I missed that special error handling too. The final fixup looks
fine.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

