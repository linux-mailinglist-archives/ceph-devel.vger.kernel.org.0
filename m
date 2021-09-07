Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFE44028DB
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Sep 2021 14:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245607AbhIGMgO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Sep 2021 08:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244785AbhIGMgN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 08:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D6D0604AC;
        Tue,  7 Sep 2021 12:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631018107;
        bh=7i2jzy/I4I4g/ZUF0B0sIM+Mb11FSNK6NbhlcjQoZKY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EB92r4B9+2GARaHSjCvoyyCFPmP7o0T2eWtuW38/V4Nb7FEXJfDdrZzpirXnI3bxu
         ZrfMNIu8usiK+rIuCth4q/uTIt2InNDFiwZVI9kYeLbyFIbWUPGBCDanMt3mo3ro5R
         9c4ZKia8sv/NNNAYS6gqahSeNiCnhDm82dsXd2Ju2TxZuE1Q94ZbQreZkBpFB8syX1
         Psdu7cbIwJnWI2IWXxDQh4ehzfRclphl9nlkwrvGt0xG2MXjCHG91BLPwX2SP5dwBJ
         zT87Wtsgj/V28dfPSDWtOZaKoRqnHoPqEdOg3xwcM2VTja5oc9DxndjT5LXTMYpRba
         sYhN90wJ/zpig==
Message-ID: <02f2f77423ec1e6e5b23b452716b21c36a5b67da.camel@kernel.org>
Subject: Re: [PATCH RFC 0/2] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 07 Sep 2021 08:35:06 -0400
In-Reply-To: <20210903081510.982827-1-xiubli@redhat.com>
References: <20210903081510.982827-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-09-03 at 16:15 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This patch series is based Jeff's ceph-fscrypt-size-experimental
> branch in https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
> 
> This is just a draft patch and need to rebase or recode after Jeff
> finished his huge patch set.
> 
> Post the patch out for advices and ideas. Thanks.
> 

I'll take a look. Going forward though, it'd probably be best for you to
just take over development of the entire ceph-fscrypt-size series
instead of trying to develop on top of my branch.

That branch is _very_ rough anyway. Just clone the branch into your tree
and then you can drop or change patches in it as you see fit.

> ====
> 
> This approach will not do the rmw immediately after the file is
> truncated. If the truncate size is aligned to the BLOCK SIZE, so
> there no need to do the rmw and only in unaligned case will the
> rmw is needed.
> 
> And the 'fscrypt_file' field will be cleared after the rmw is done.
> If the 'fscrypt_file' is none zero that means after the kclient
> reading that block to local buffer or pagecache it needs to do the
> zeroing of that block in range of [fscrypt_file, round_up(fscrypt_file,
> BLOCK SIZE)).
> 
> Once any kclient has dirty that block and write it back to ceph, the
> 'fscrypt_file' field will be cleared and set to 0. More detail please
> see the commit comments in the second patch.
> 

That sounds odd. How do you know where the file ends once you zero out
fscrypt_file?

/me goes to look at the patches...

> There also need on small work in Jeff's MDS PR in cap flushing code
> to clear the 'fscrypt_file'.
> 
> 
> Xiubo Li (2):
>   Revert "ceph: make client zero partial trailing block on truncate"
>   ceph: truncate the file contents when needed when file scrypted
> 
>  fs/ceph/addr.c  | 19 ++++++++++++++-
>  fs/ceph/caps.c  | 24 ++++++++++++++++++
>  fs/ceph/file.c  | 65 ++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/ceph/inode.c | 48 +++++++++++++++++++-----------------
>  fs/ceph/super.h | 13 +++++++---
>  5 files changed, 138 insertions(+), 31 deletions(-)
> 

-- 
Jeff Layton <jlayton@kernel.org>

