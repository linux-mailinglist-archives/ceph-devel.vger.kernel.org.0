Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E3375E12
	for <lists+ceph-devel@lfdr.de>; Fri,  7 May 2021 02:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhEGAyf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 May 2021 20:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhEGAyc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 May 2021 20:54:32 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01C2C061574;
        Thu,  6 May 2021 17:53:33 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1leokC-00C2LI-7e; Fri, 07 May 2021 00:53:28 +0000
Date:   Fri, 7 May 2021 00:53:28 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Ceph updates for 5.13-rc1
Message-ID: <YJSPiFo9b7O75xrW@zeniv-ca.linux.org.uk>
References: <20210506143312.22281-1-idryomov@gmail.com>
 <CAHk-=wgjQgUYrMD_tTm5M1BqeN5Z7h_z5EkU65RXAnEevsTDLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgjQgUYrMD_tTm5M1BqeN5Z7h_z5EkU65RXAnEevsTDLA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 06, 2021 at 10:51:33AM -0700, Linus Torvalds wrote:
> On Thu, May 6, 2021 at 7:33 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > There is a merge conflict in fs/ceph/dir.c because Jeff's inode
> > type handling patch went through the vfs tree together with Al's
> > inode_wrong_type() helper.  for-linus-merged has the resolution.
> 
> Actually, the linux-next resolution looks wrong - or at least
> unnecessary - to me.
> 
> The conversion to d_splice_alias() means that the IS_ERR() test is now
> pointless, because d_splice_alias() handles an error-pointer natively,
> and just returns the error back with ERR_CAST().
> 
> So the proper resolution seems to be to just drop the IS_ERR().

Agreed; -next resolution is not wrong per se, but it's not needed -
d_splice_alias(ERR_PTR(e), d) == ERR_PTR(e) for any e in -4095..-1,
so the variant of resolution in mainline merge will do the right thing.
