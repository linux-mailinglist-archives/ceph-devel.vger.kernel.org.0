Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7266E49B2CB
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jan 2022 12:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356913AbiAYLQf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 06:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380876AbiAYLN6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jan 2022 06:13:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE2EC061749
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jan 2022 03:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B3DD615EF
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jan 2022 11:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67483C340E0;
        Tue, 25 Jan 2022 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643109235;
        bh=DXsfcZEYOgbiqyUB5nYYkqJrO8xQwFnIHg0iAeREeq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aTgRoc2m6oGr7ETj4c99phIjYAG2j6tmaYnOGg5ZpvoBhN6NdRuYx9xVDjfkOnaNh
         CbHoQlMHha5QC4UKTSypfDaWoe48gmbdr3przIA2gFRiPLRx7o1gt2BWMGDpWXSsVn
         hainM9481p1GVxBvThDPbfE9S8tcckf2K+D+aHTY+qKzG+Odg0BnBLbvH5n3ihjUN4
         6KhLWi/J2JgirKg3cCly9IEj8TZq0s2jfePd5PgLmGPUR+ZwSBbXWMwwBJLMIogcTe
         Gl/2/eg9YxcQyMr/8cotbq1TlZOXADLrs2OYSCMQqgJTEFhU22UuCJKuhYNb9cwp/A
         IyZo6S9X1zQww==
Date:   Tue, 25 Jan 2022 12:13:50 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Paul Moore <paul@paul-moore.com>, Stephen Muth <smuth4@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: "kernel NULL pointer dereference" crash when attempting a write
Message-ID: <20220125111350.t2jgmqdvshgr7doi@wittgenstein>
References: <CAM2jsSiHK_++SggmRyRbCxZ58hywxeZsJJMJHpQfbAz-5AfJ0g@mail.gmail.com>
 <CAHC9VhR1efuTR_zLLhmOyS4EHT1oHgA1d_StooKXmFf9WGODyA@mail.gmail.com>
 <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 05:54:57AM -0500, Jeff Layton wrote:
> On Mon, 2022-01-24 at 21:45 -0500, Paul Moore wrote:
> > On Mon, Jan 24, 2022 at 8:51 PM Stephen Muth <smuth4@gmail.com> wrote:
> > > 
> > > Hello,
> > > 
> > > I'm seeing an Oops in the kernel whenever I try to make changes (e.g. `touch`ing a file) in a cephfs mount on Arch running kernel 5.16.2. Reading works fine up until a modification is attempted, and then all IO will start hanging.
> > > 
> > > This appears to be directly related to "security: Return xattr name from security_dentry_init_security()" (commit 15bf323), as recompiling with just that change reverted makes the issue go away. The same cluster is actively receiving writes from older kernels (5.13), and it was initially reported at https://bugs.archlinux.org/task/73408, where a user reports that 5.15 kernels also work.
> > > 
> > > /proc/version: Linux version 5.16.2-arch1-1 (linux@archlinux) (gcc (GCC) 11.1.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Thu, 20 Jan 2022 16:18:29 +0000
> > > distro / arch: Arch Linux / x86_64
> > > SELinux is not enabled
> > > ceph cluster version: 16.2.7 (dd0603118f56ab514f133c8d2e3adfc983942503)
> > > 
> > > relevant dmesg output:
> > > [   30.947129] BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > [   30.947206] #PF: supervisor read access in kernel mode
> > > [   30.947258] #PF: error_code(0x0000) - not-present page
> > > [   30.947310] PGD 0 P4D 0
> > > [   30.947342] Oops: 0000 [#1] PREEMPT SMP PTI
> > > [   30.947388] CPU: 5 PID: 778 Comm: touch Not tainted 5.16.2-arch1-1 #1 86fbf2c313cc37a553d65deb81d98e9dcc2a3659
> > > [   30.947486] Hardware name: Gigabyte Technology Co., Ltd. B365M DS3H/B365M DS3H, BIOS F5 08/13/2019
> > > [   30.947569] RIP: 0010:strlen+0x0/0x20
> > > [   30.947616] Code: b6 07 38 d0 74 16 48 83 c7 01 84 c0 74 05 48 39 f7 75 ec 31 c0 31 d2 89 d6 89 d7 c3 48 89 f8 31 d2 89 d6 89 d7 c3 0
> > > f 1f 40 00 <80> 3f 00 74 12 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 31 ff
> > > [   30.947782] RSP: 0018:ffffa4ed80ffbbb8 EFLAGS: 00010246
> > > [   30.947836] RAX: 0000000000000000 RBX: ffffa4ed80ffbc60 RCX: 0000000000000000
> > > [   30.947904] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > [   30.947971] RBP: ffff94b0d15c0ae0 R08: 0000000000000000 R09: 0000000000000000
> > > [   30.948040] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > > [   30.948106] R13: 0000000000000001 R14: ffffa4ed80ffbc60 R15: 0000000000000000
> > > [   30.948174] FS:  00007fc7520f0740(0000) GS:ffff94b7ced40000(0000) knlGS:0000000000000000
> > > [   30.948252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   30.948308] CR2: 0000000000000000 CR3: 0000000104a40001 CR4: 00000000003706e0
> > > [   30.948376] Call Trace:
> > > [   30.948404]  <TASK>
> > > [   30.948431]  ceph_security_init_secctx+0x7b/0x240 [ceph 49f9c4b9bf5be8760f19f1747e26da33920bce4b]
> > 
> > My guess is that the "name_len = strlen(name);" line in
> > ceph_security_init_secctx() is causing the problem as "name" is likely
> > NULL/garbage without any LSMs configured for that hook.
> > 
> > [SIDE NOTE: we should remove the comment block directly above that
> > line as it no longer applies, arguably commit 15bf32398ad4 should have
> > removed it.]
> > 
> > I'm open to suggestions on the best approach, but my gut feeling is
> > that the fix is to have the security_dentry_init_security() hook set
> > the xattr_name parameter to NULL before calling into the LSMs and then
> > the callers should check for "name == NULL" on return.  In the case of
> > ceph that would probably be something like this:
> > 
> >   name_len = (name ? strlen(name) : 0);
> > 
> > ... with fuse looking very similar, although fuse appears to need a
> > "strlen(name) + 1".  We don't have to worry about this for NFSv4 as it
> > doesn't use the xattr name.
> > 
> > Thoughts?
> > 
> 
> Actually, if we don't get an xattr name back from the call, we don't
> need to do anything in ceph_security_init_secctx(). Stephen, could you
> test this patch and let us know if it fixes it?
> 
> -------------------8<--------------------
> 
> [PATCH] ceph: when no LSM is configured, don't set security xattr
> 
> If the xattr name pointer is not populated after the call to
> security_dentry_init_security(), then we should assume that no LSM is
> configured and that no xattr needs to be set for it. Also, remove a
> now-defunct comment.
> 
> Fixes: 15bf32398ad4 ("security: Return xattr name from security_dentry_init_security()")
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Reported-by: Stephen Muth <smuth4@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/xattr.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index fcf7dfdecf96..a61e1adb49a9 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1306,7 +1306,7 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
>  			   struct ceph_acl_sec_ctx *as_ctx)
>  {
>  	struct ceph_pagelist *pagelist = as_ctx->pagelist;
> -	const char *name;
> +	const char *name = NULL;
>  	size_t name_len;
>  	int err;
>  
> @@ -1319,6 +1319,12 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
>  		goto out;
>  	}
>  
> +	/* No LSM configured? Do nothing. */
> +	if (!name) {

Excuse my french but that reads very riské. Can we somehow make
security_dentry_init_security() return an error number that caller's
like ceph can use to skip?
I think that returning 0 from security_dentry_init_security() and having
*name be returned as NULL is very fragile.
