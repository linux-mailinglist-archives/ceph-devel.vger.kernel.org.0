Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C5C30ED9E
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Feb 2021 08:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhBDHo1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Feb 2021 02:44:27 -0500
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:46230 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232941AbhBDHoY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Feb 2021 02:44:24 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2021 02:44:24 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 098F41801495E
        for <ceph-devel@vger.kernel.org>; Thu,  4 Feb 2021 07:34:57 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 98740180A7FC7;
        Thu,  4 Feb 2021 07:34:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3150:3352:3590:3622:3865:3867:3868:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12297:12438:12740:12895:13069:13161:13229:13311:13357:13439:13894:14659:21080:21451:21611:21627:21740:21809:21990:30012:30025:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: game57_2706cde275da
X-Filterd-Recvd-Size: 1955
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Thu,  4 Feb 2021 07:34:06 +0000 (UTC)
Message-ID: <599ba2c6cebb8d8079d6af61d5987b958b2732f8.camel@perches.com>
Subject: Re: [PATCH] ceph: minor coding style tweaks
From:   Joe Perches <joe@perches.com>
To:     Zhiyuan Dai <daizhiyuan@phytium.com.cn>, jlayton@kernel.org,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 03 Feb 2021 23:34:05 -0800
In-Reply-To: <1612420334-1112-1-git-send-email-daizhiyuan@phytium.com.cn>
References: <1612420334-1112-1-git-send-email-daizhiyuan@phytium.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-02-04 at 14:32 +0800, Zhiyuan Dai wrote:
> Fixed some coding style issues, improve code reading.

Might describe the patch does 3 things:

o Move the pointer location
	struct foo* bar; -> struct foo *bar;
o Move brace position
  from
	struct foo
	{
  to
	struct foo {
o Alignment to open parenthesis

And one more comment:

> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
[]
> @@ -309,8 +309,8 @@ static int ceph_fill_dirfrag(struct inode *inode,
>  
>  static int frag_tree_split_cmp(const void *l, const void *r)
>  {
> -	struct ceph_frag_tree_split *ls = (struct ceph_frag_tree_split*)l;
> -	struct ceph_frag_tree_split *rs = (struct ceph_frag_tree_split*)r;
> +	struct ceph_frag_tree_split *ls = (struct ceph_frag_tree_split *)l;
> +	struct ceph_frag_tree_split *rs = (struct ceph_frag_tree_split *)r;

It's unnecessary to cast void pointers and it's bad form to lose
the const qualifier.

	const struct ceph_frag_tree_split *ls = l;
	const struct ceph_frag_tree_split *rs = r;

>  	return ceph_frag_compare(le32_to_cpu(ls->frag),
>  				 le32_to_cpu(rs->frag));
>  }


