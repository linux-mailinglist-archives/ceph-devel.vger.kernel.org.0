Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C8016B3D7
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2020 23:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgBXWYi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Feb 2020 17:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWYi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 17:24:38 -0500
Received: from vulkan (unknown [4.28.11.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD2C21744;
        Mon, 24 Feb 2020 22:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582583077;
        bh=PIalgebfcM5GH35VPQjJzn/fOtpwniantOEfJ6q9hlU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UYdLI95CBAKTjVMoMkIR/cRcSmG2Scar+7jc/Srgd1msjjQoQm/qQnZmsu7xoXL2d
         21tiylP3h47ziTWC7l60rEwFRhHisdomttMrY75zY3E6JBszCFivse042TzQ9YpzZr
         j6JbXeBthuoAcTRav0mwaVQcXgTtfJ7JoWoleSRU=
Message-ID: <8a9c3239eab504f47b93377998312c447a1eec41.camel@kernel.org>
Subject: Re: [PATCH] ceph: add 'fs' mount option support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 24 Feb 2020 14:24:34 -0800
In-Reply-To: <19a375d6b80aaaeab0133f53e3bba2d067e3699d.camel@kernel.org>
References: <20200223021440.40257-1-xiubli@redhat.com>
         <552341c730d2835b1492599fce319ae91a34f504.camel@kernel.org>
         <33fb49fe-87bc-b5d3-f717-3c22c7a15030@redhat.com>
         <19a375d6b80aaaeab0133f53e3bba2d067e3699d.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-02-24 at 14:20 -0800, Jeff Layton wrote:
> On Mon, 2020-02-24 at 10:41 +0800, Xiubo Li wrote:
> > On 2020/2/23 22:56, Jeff Layton wrote:
> > > On Sat, 2020-02-22 at 21:14 -0500, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > > 
> > > > The 'fs' here will be cleaner when specifying the ceph fs name,
> > > > and we can easily get the corresponding name from the `ceph fs
> > > > dump`:
> > > > 
> > > > [...]
> > > > Filesystem 'a' (1)
> > > > fs_name	a
> > > > epoch	12
> > > > flags	12
> > > > [...]
> > > > 
> > > > The 'fs' here just an alias name for 'mds_namespace' mount options,
> > > > and we will keep 'mds_namespace' for backwards compatibility.
> > > > 
> > > > URL: https://tracker.ceph.com/issues/44214
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > It looks like mds_namespace feature went into the kernel in 2016 (in
> > > v4.7). We're at v5.5 today, so that's a large swath of kernels in the
> > > field that only support the old option.
> > > 
> > > While I agree that 'fs=' would have been cleaner and more user-friendly,
> > > I've found that it's just not worth it to add mount option aliases like
> > > this unless you have a really good reason. It all ends up being a huge
> > > amount of churn for little benefit.
> > > 
> > > The problem with changing it after the fact like this is that you still
> > > have to support both options forever. Removing support isn't worth the
> > > pain as you can break working environments. When working environments
> > > upgrade they won't change to use the new option (why bother?)
> > > 
> > > Maybe it would be good to start this change by doing a "fs=" to
> > > "mds_namespace=" translation in the mount helper? That would make the
> > > new option work across older kernel releases too, and make it simpler to
> > > document what options are supported.
> > 
> > This sounds a pretty good idea for me.
> > 
> > 
> > > > @@ -561,8 +562,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> > > >   	if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
> > > >   		seq_puts(m, ",copyfrom");
> > > >   
> > > > -	if (fsopt->mds_namespace)
> > > > -		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
> > > > +	if (fsopt->fs_name)
> > > > +		seq_show_option(m, "fs", fsopt->fs_name);
> > > Someone will mount with mds_namespace= but then that will be converted
> > > to fs= when displaying options here. It's not necessarily a problem but
> > > it may be noticed by some users.
> > 
> > Yeah, but if we convert 'fs=' to 'mds_namespace=' in userland and here 
> > it will always showing with 'mds_namespace=', won't it be the same issue?
> > 
> > Or should we covert it to "fs/mds_namespace=" here ? Will it make sense ?
> > 
> 
> Now that I think about it more, it's probably not a problem either way,
> but we should probably convert it to read 'fs=' here since that's what
> we're planning to encourage people to use long-term.
> 

To be even more clear:

We should probably take your initial patch (or something like it) into
the kernel as well, but also change the mount helper to smooth over the
difference in the option handling there.  Once your userland changes
are merged, let me know and I'll plan to re-review and merge this.



-- 
Jeff Layton <jlayton@kernel.org>

