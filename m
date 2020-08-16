Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794F32457D9
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Aug 2020 16:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgHPOAu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Aug 2020 10:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbgHPOAt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 16 Aug 2020 10:00:49 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F67A20735;
        Sun, 16 Aug 2020 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597586448;
        bh=ORDdZnkhKIIphacByBZiqCEauCeJidLk3JuuxwwjEsw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BauJmnr+Ay7ZfeobNWDZKa4kywlEYkqYdZV49veJ62xlKhT2Myiz8WlwtWXZiWc5T
         koa78xoPs3sc8L352uU2pHXzruE61QOrYF+H/9Svjr4M0ZS+O5TijS0ePovpeSJ4II
         Z2a3ijRkc7+QWoncRCvQe1ZZmlOsZdX9uOqnG7Lc=
Message-ID: <116297e8efab260d8dd61e9dcc36aa3414e9b1d9.camel@kernel.org>
Subject: Re: [PATCH] ceph: remove unnecessary return in switch statement
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sun, 16 Aug 2020 10:00:46 -0400
In-Reply-To: <877du1h7db.fsf@suse.de>
References: <20200814093822.GA293898@suse.de>
         <a1a68d9a887148ae9a80ca103d112e6b@AcuMS.aculab.com>
         <877du1h7db.fsf@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-08-14 at 11:03 +0100, Luis Henriques wrote:
> David Laight <David.Laight@ACULAB.COM> writes:
> 
> > From: Luis Henriques
> > > Sent: 14 August 2020 10:38
> > > 
> > > Since there's a return immediately after the 'break', there's no need for
> > > this extra 'return' in the S_IFDIR case.
> > > 
> > > Signed-off-by: Luis Henriques <lhenriques@suse.de>
> > > ---
> > >  fs/ceph/file.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index d51c3f2fdca0..04ab99c0223a 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -256,8 +256,6 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
> > >  	case S_IFDIR:
> > >  		ret = ceph_init_file_info(inode, file, fmode,
> > >  						S_ISDIR(inode->i_mode));
> > > -		if (ret)
> > > -			return ret;
> > >  		break;
> > > 
> > >  	case S_IFLNK:
> > 
> > I'd move the other way and just do:
> > 		return ceph_init_file_info(...);
> 
> Sure, that would work too, although my preference would be to have a
> single function exit point.  But I'll leave that decision to Jeff :-)
> 

I think I agree with Luis here (though it's really a bit subjective). I
don't think it'll matter much to the compiled result either way, and
that will probably be better if this function grows in complexity.

I'll plan to merge this patch in the next day or so.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

