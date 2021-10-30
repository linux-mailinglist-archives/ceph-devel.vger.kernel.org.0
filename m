Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86C944086B
	for <lists+ceph-devel@lfdr.de>; Sat, 30 Oct 2021 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhJ3Kz1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 Oct 2021 06:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhJ3Kz0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 06:55:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09D1060F4B;
        Sat, 30 Oct 2021 10:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635591176;
        bh=Lv7W9it9o0C0bEXTJ6qMW+Yvpvo/vB7TRv4JoDky6CE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jfI1bj0v5RnfTVb5ophk2WIKXLFEeun3NV1vJeeTuTGrvOp4SwUocWVM6g8hiHcwx
         T3DzwPXTLBJ8IBkNTLoQY2i3Q3IDMb4bbHuYT4PK5EQFghH59DheUv/s4Ar6pHZ3AS
         7EYkdFzdJanLpbYGNeVNLJU2XwxKmLrTqXNioHfGw8xWPPNXhJ9v7ZiUpgNamIKx45
         isqCoNIHqbavHGIdXqeuZD4N8RamcGmLqOpqSg6Fv9dsKvl8RWSoBChwmnEcfDVE/K
         xK0ON4Z/JhCiUaZNYT1SoRzAhYG15K08Sj5MKhZlMiJFvCE6SMNX4AIpiJFn56btw0
         lUO1zqht75jrw==
Message-ID: <fdf2815ac335c5a6ff71cd1baa9b93f488a0b05c.camel@kernel.org>
Subject: Re: [PATCH v3 4/4] ceph: add truncate size handling support for
 fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Sat, 30 Oct 2021 06:52:54 -0400
In-Reply-To: <8603888b-a9d3-21d6-441f-d358c5e9e1ea@redhat.com>
References: <20211028091438.21402-1-xiubli@redhat.com>
         <20211028091438.21402-5-xiubli@redhat.com>
         <37ca7a43ec7b9d796d4d8fb962309278c0df7d76.camel@kernel.org>
         <8603888b-a9d3-21d6-441f-d358c5e9e1ea@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2021-10-30 at 14:20 +0800, Xiubo Li wrote:
> 
> [...]
> 
> > > @@ -2473,7 +2621,23 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
> > >   		req->r_args.setattr.mask = cpu_to_le32(mask);
> > >   		req->r_num_caps = 1;
> > >   		req->r_stamp = attr->ia_ctime;
> > > +		if (fill_fscrypt) {
> > > +			err = fill_fscrypt_truncate(inode, req, attr);
> > > +			if (err)
> > > +				goto out;
> > > +		}
> > > +
> > > +		/*
> > > +		 * The truncate will return -EAGAIN when some one
> > > +		 * has updated the last block before the MDS hold
> > > +		 * the xlock for the FILE lock. Need to retry it.
> > > +		 */
> > >   		err = ceph_mdsc_do_request(mdsc, NULL, req);
> > > +		if (err == -EAGAIN) {
> > > +			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
> > > +			     inode, err, ceph_cap_string(dirtied), mask);
> > > +			goto retry;
> > > +		}
> > The rest looks reasonable. We may want to cap the number of retries in
> > case something goes really wrong or in the case of a livelock with a
> > competing client. I'm not sure what a reasonable number of tries would
> > be though -- 5? 10? 100? We may want to benchmark out how long this rmw
> > operation takes and then we can use that to determine a reasonable
> > number of tries.
> 
> <7>[  330.648749] ceph:  setattr 00000000197f0d87 issued pAsxLsXsxFsxcrwb
> <7>[  330.648752] ceph:  setattr 00000000197f0d87 size 11 -> 2
> <7>[  330.648756] ceph:  setattr 00000000197f0d87 mtime 
> 1635574177.43176541 -> 1635574210.35946684
> <7>[  330.648760] ceph:  setattr 00000000197f0d87 ctime 
> 1635574177.43176541 -> 1635574210.35946684 (ignored)
> <7>[  330.648765] ceph:  setattr 00000000197f0d87 ATTR_FILE ... hrm!
> ...
> 
> <7>[  330.653696] ceph:  fill_fscrypt_truncate 00000000197f0d87 size 
> dropping cap refs on Fr
> ...
> 
> <7>[  330.697464] ceph:  setattr 00000000197f0d87 result=0 (Fx locally, 
> 4128 remote)
> 
> It takes around 50ms.
> 
> Shall we retry 20 times ?
> 

Sounds like a good place to start.

> > 
> > If you run out of tries, you could probably  just return -EAGAIN in that
> > case. That's not listed in the truncate(2) manpage, but it seems like a
> > reasonable way to handle that sort of problem.
> > 
> [...]
> 

-- 
Jeff Layton <jlayton@kernel.org>

