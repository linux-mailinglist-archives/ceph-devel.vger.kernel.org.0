Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00D1446232
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 11:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhKEKc3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 06:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233108AbhKEKc3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 06:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E9EB60F70;
        Fri,  5 Nov 2021 10:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636108189;
        bh=s228q2e4daFKzTenw27BtwLH8faeTIKlRHPGcpTofkE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jbnVVo1suhMVSW4i8cinfLiytdH+V5Wu35jMKk7qulwvPZvUhyqjVn8+XPIEips+w
         i1T7XXZYIU7+qeWyLvh3pntvaoFjinTOAeIBWgPqymy0Z/mIkiza2AvQPBtZac2fg2
         lvhCJTDnJtpSmtrVPjqruST53ZkwCVJH0QVZ44roArMulzu81KskaIWFyekhI0kUCI
         FWRWKY5cYjRS+ASC6Xrju0gkiLtf2FVur2MvZ1x2EZAUaL7EayRW06B2uGs99aqwUB
         E34khtKtsIUPGxi08KhPT7DlLy0uoPiSozzGzHAsHg+aBoGIDQniSjoLYnPh2lOp2l
         9pvCxoAhuxMgw==
Message-ID: <a8651d8cec901eff76d35f2ef9d05b093d1e1d1a.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix incorrectly decoding the mdsmap bug
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 05 Nov 2021 06:29:48 -0400
In-Reply-To: <20211105093418.261469-1-xiubli@redhat.com>
References: <20211105093418.261469-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-11-05 at 17:34 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When decreasing the 'max_mds' in the cephfs cluster, when the extra
> MDS or MDSes are not removed yet, the mdsmap may only decreased the
> 'max_mds' but still having the that or those MDSes 'in' or in the
> export targets list.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mdsmap.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 61d67cbcb367..30387733765d 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -263,10 +263,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>  				goto nomem;
>  			for (j = 0; j < num_export_targets; j++) {
>  				target = ceph_decode_32(&pexport_targets);
> -				if (target >= m->possible_max_rank) {
> -					err = -EIO;
> -					goto corrupt;
> -				}
>  				info->export_targets[j] = target;
>  			}
>  		} else {

Thanks Xiubo, looks good. Given the severity when mdsmap decoding fails,
I think we should probably mark this for stable too. Let me know if you
have any objections.
-- 
Jeff Layton <jlayton@kernel.org>
