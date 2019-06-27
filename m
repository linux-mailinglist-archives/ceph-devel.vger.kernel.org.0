Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90354584AD
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2019 16:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0OlK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Jun 2019 10:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbfF0OlK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 10:41:10 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AA3920828;
        Thu, 27 Jun 2019 14:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561646469;
        bh=5g54SfqiMdUp+4gMMz3X6m++ycp9PeKR9MwOfbhwIzE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MWhR04I3jgGAEEkajU1SvPQcpslxrGkANJNUVXuCMqeZbtR5fRwTqPmPRG+5vXXUZ
         hQopFfpzShF4Im/MndRRfeq3Uc/OXGIUCucCzQhvyQw5wYfA6tQyGL1Prx8qfV4Z4j
         2PGt2/85kPZhZFccxYSsJEHEshyJBrd9Kn5/zb0I=
Message-ID: <0459c2a46200194c14b7474f55071b12fbc3d594.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: initialize superblock s_time_gran to 1
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 27 Jun 2019 10:41:07 -0400
In-Reply-To: <20190627135122.12817-1-lhenriques@suse.com>
References: <20190627135122.12817-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-06-27 at 14:51 +0100, Luis Henriques wrote:
> Having granularity set to 1us results in having inode timestamps with a
> accurancy different from the fuse client (i.e. atime, ctime and mtime will
> always end with '000').  This patch normalizes this behaviour and sets the
> granularity to 1.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Hi!
> 
> As far as I could see there are no other side-effects of changing
> s_time_gran but I'm really not sure why it was initially set to 1000 in
> the first place so I may be missing something.
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index d57fa60dcd43..35dd75bc9cd0 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -980,7 +980,7 @@ static int ceph_set_super(struct super_block *s, void *data)
>  	s->s_d_op = &ceph_dentry_ops;
>  	s->s_export_op = &ceph_export_ops;
>  
> -	s->s_time_gran = 1000;  /* 1000 ns == 1 us */
> +	s->s_time_gran = 1;
>  
>  	ret = set_anon_super(s, NULL);  /* what is that second arg for? */
>  	if (ret != 0)


Looks like it was set that way since the client code was originally
merged. Was this an earlier limitation of ceph that is no longer
applicable?

In any case, I see no need at all to keep this at 1000, so:

Reviewed-by: Jeff Layton <jlayton@kernel.org>

