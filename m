Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5108149B816
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jan 2022 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353223AbiAYP7V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 10:59:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349301AbiAYP4o (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 10:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643126202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPNWS5MB+UsV3nOqbSQSg2Qmb4/P8mE0PMdPU9qFWz0=;
        b=PpGZ4MQcngHlET9KLhKo+60KhmnHDZCbVuCbFEVqWdbd3MkQiGRfis8fNxuoCtqg+4mluW
        yR1bZ/qntF/F0QggPfOKwpgDLa+avMJQfRcw1YW7FK6VXxxCMAp7/1PtXrNNQezFbxeVkH
        LokkMZK2B11VuQrAqZWp9QbJV8sJdYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-rSCrn7G4Nui85PggFRjR7A-1; Tue, 25 Jan 2022 10:56:39 -0500
X-MC-Unique: rSCrn7G4Nui85PggFRjR7A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C761A190B2CD;
        Tue, 25 Jan 2022 15:56:37 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.9.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13F5C798AC;
        Tue, 25 Jan 2022 15:56:37 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 8BA8C223DA6; Tue, 25 Jan 2022 10:56:36 -0500 (EST)
Date:   Tue, 25 Jan 2022 10:56:36 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Muth <smuth4@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: "kernel NULL pointer dereference" crash when attempting a write
Message-ID: <YfAdtAaUfz38xtmf@redhat.com>
References: <CAM2jsSiHK_++SggmRyRbCxZ58hywxeZsJJMJHpQfbAz-5AfJ0g@mail.gmail.com>
 <CAHC9VhR1efuTR_zLLhmOyS4EHT1oHgA1d_StooKXmFf9WGODyA@mail.gmail.com>
 <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
 <20220125111350.t2jgmqdvshgr7doi@wittgenstein>
 <d5490a7c87b8c435b3c7bdb8d2c8edef2c2a576a.camel@kernel.org>
 <20220125121213.ontt4fide32phuzl@wittgenstein>
 <ab92b28e953601785467cdf8ca67dd5b0ef55105.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab92b28e953601785467cdf8ca67dd5b0ef55105.camel@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 07:32:19AM -0500, Jeff Layton wrote:
> On Tue, 2022-01-25 at 13:12 +0100, Christian Brauner wrote:
> > On Tue, Jan 25, 2022 at 06:25:39AM -0500, Jeff Layton wrote:
> > > On Tue, 2022-01-25 at 12:13 +0100, Christian Brauner wrote:
> > > > On Tue, Jan 25, 2022 at 05:54:57AM -0500, Jeff Layton wrote:
> > > > > On Mon, 2022-01-24 at 21:45 -0500, Paul Moore wrote:
> > > > > > On Mon, Jan 24, 2022 at 8:51 PM Stephen Muth <smuth4@gmail.com> wrote:
> > > > > > > 
> > > > > > > Hello,
> > > > > > > 
> > > > > > > I'm seeing an Oops in the kernel whenever I try to make changes (e.g. `touch`ing a file) in a cephfs mount on Arch running kernel 5.16.2. Reading works fine up until a modification is attempted, and then all IO will start hanging.
> > > > > > > 
> > > > > > > This appears to be directly related to "security: Return xattr name from security_dentry_init_security()" (commit 15bf323), as recompiling with just that change reverted makes the issue go away. The same cluster is actively receiving writes from older kernels (5.13), and it was initially reported at https://bugs.archlinux.org/task/73408, where a user reports that 5.15 kernels also work.
> > > > > > > 
> > > > > > > /proc/version: Linux version 5.16.2-arch1-1 (linux@archlinux) (gcc (GCC) 11.1.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Thu, 20 Jan 2022 16:18:29 +0000
> > > > > > > distro / arch: Arch Linux / x86_64
> > > > > > > SELinux is not enabled
> > > > > > > ceph cluster version: 16.2.7 (dd0603118f56ab514f133c8d2e3adfc983942503)
> > > > > > > 
> > > > > > > relevant dmesg output:
> > > > > > > [   30.947129] BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > > > > > [   30.947206] #PF: supervisor read access in kernel mode
> > > > > > > [   30.947258] #PF: error_code(0x0000) - not-present page
> > > > > > > [   30.947310] PGD 0 P4D 0
> > > > > > > [   30.947342] Oops: 0000 [#1] PREEMPT SMP PTI
> > > > > > > [   30.947388] CPU: 5 PID: 778 Comm: touch Not tainted 5.16.2-arch1-1 #1 86fbf2c313cc37a553d65deb81d98e9dcc2a3659
> > > > > > > [   30.947486] Hardware name: Gigabyte Technology Co., Ltd. B365M DS3H/B365M DS3H, BIOS F5 08/13/2019
> > > > > > > [   30.947569] RIP: 0010:strlen+0x0/0x20
> > > > > > > [   30.947616] Code: b6 07 38 d0 74 16 48 83 c7 01 84 c0 74 05 48 39 f7 75 ec 31 c0 31 d2 89 d6 89 d7 c3 48 89 f8 31 d2 89 d6 89 d7 c3 0
> > > > > > > f 1f 40 00 <80> 3f 00 74 12 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 31 ff
> > > > > > > [   30.947782] RSP: 0018:ffffa4ed80ffbbb8 EFLAGS: 00010246
> > > > > > > [   30.947836] RAX: 0000000000000000 RBX: ffffa4ed80ffbc60 RCX: 0000000000000000
> > > > > > > [   30.947904] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > > > > > [   30.947971] RBP: ffff94b0d15c0ae0 R08: 0000000000000000 R09: 0000000000000000
> > > > > > > [   30.948040] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > > > > > > [   30.948106] R13: 0000000000000001 R14: ffffa4ed80ffbc60 R15: 0000000000000000
> > > > > > > [   30.948174] FS:  00007fc7520f0740(0000) GS:ffff94b7ced40000(0000) knlGS:0000000000000000
> > > > > > > [   30.948252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > > > [   30.948308] CR2: 0000000000000000 CR3: 0000000104a40001 CR4: 00000000003706e0
> > > > > > > [   30.948376] Call Trace:
> > > > > > > [   30.948404]  <TASK>
> > > > > > > [   30.948431]  ceph_security_init_secctx+0x7b/0x240 [ceph 49f9c4b9bf5be8760f19f1747e26da33920bce4b]
> > > > > > 
> > > > > > My guess is that the "name_len = strlen(name);" line in
> > > > > > ceph_security_init_secctx() is causing the problem as "name" is likely
> > > > > > NULL/garbage without any LSMs configured for that hook.
> > > > > > 
> > > > > > [SIDE NOTE: we should remove the comment block directly above that
> > > > > > line as it no longer applies, arguably commit 15bf32398ad4 should have
> > > > > > removed it.]
> > > > > > 
> > > > > > I'm open to suggestions on the best approach, but my gut feeling is
> > > > > > that the fix is to have the security_dentry_init_security() hook set
> > > > > > the xattr_name parameter to NULL before calling into the LSMs and then
> > > > > > the callers should check for "name == NULL" on return.  In the case of
> > > > > > ceph that would probably be something like this:
> > > > > > 
> > > > > >   name_len = (name ? strlen(name) : 0);
> > > > > > 
> > > > > > ... with fuse looking very similar, although fuse appears to need a
> > > > > > "strlen(name) + 1".  We don't have to worry about this for NFSv4 as it
> > > > > > doesn't use the xattr name.
> > > > > > 
> > > > > > Thoughts?
> > > > > > 
> > > > > 
> > > > > Actually, if we don't get an xattr name back from the call, we don't
> > > > > need to do anything in ceph_security_init_secctx(). Stephen, could you
> > > > > test this patch and let us know if it fixes it?
> > > > > 
> > > > > -------------------8<--------------------
> > > > > 
> > > > > [PATCH] ceph: when no LSM is configured, don't set security xattr
> > > > > 
> > > > > If the xattr name pointer is not populated after the call to
> > > > > security_dentry_init_security(), then we should assume that no LSM is
> > > > > configured and that no xattr needs to be set for it. Also, remove a
> > > > > now-defunct comment.
> > > > > 
> > > > > Fixes: 15bf32398ad4 ("security: Return xattr name from security_dentry_init_security()")
> > > > > Cc: Vivek Goyal <vgoyal@redhat.com>
> > > > > Reported-by: Stephen Muth <smuth4@gmail.com>
> > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > ---
> > > > >  fs/ceph/xattr.c | 13 +++++++------
> > > > >  1 file changed, 7 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > > > index fcf7dfdecf96..a61e1adb49a9 100644
> > > > > --- a/fs/ceph/xattr.c
> > > > > +++ b/fs/ceph/xattr.c
> > > > > @@ -1306,7 +1306,7 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
> > > > >  			   struct ceph_acl_sec_ctx *as_ctx)
> > > > >  {
> > > > >  	struct ceph_pagelist *pagelist = as_ctx->pagelist;
> > > > > -	const char *name;
> > > > > +	const char *name = NULL;
> > > > >  	size_t name_len;
> > > > >  	int err;
> > > > >  
> > > > > @@ -1319,6 +1319,12 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
> > > > >  		goto out;
> > > > >  	}
> > > > >  
> > > > > +	/* No LSM configured? Do nothing. */
> > > > > +	if (!name) {
> > > > 
> > > > Excuse my french but that reads very riské. Can we somehow make
> > > > security_dentry_init_security() return an error number that caller's
> > > > like ceph can use to skip?
> > > > I think that returning 0 from security_dentry_init_security() and having
> > > > *name be returned as NULL is very fragile.
> > > 
> > > Good point. In fact, I'm not sure why he didn't get an -EOPNOTSUPP
> > > return here:
> > > 
> > >         return call_int_hook(dentry_init_security, -EOPNOTSUPP, dentry, mode,
> > >                                 name, xattr_name, ctx, ctxlen);
> > > 
> > > It looks like the second argument is what should end up being returned
> > > when there are no entries in the security_hook_list. So it seems like
> > > maybe Stephen's security_hook_list was not empty, but didn't have a
> > > vector for dentry_init_security and returned the default 0 there?
> > 
> > Yeah, I came to the exact same analysis and subsequent question in:
> > https://lore.kernel.org/ceph-devel/20220125111111.irvr4dg3i56crqrs@wittgenstein
> > 
> > It seems to me that selinux support is compiled in in archlinux but no
> > policy loaded/enabled. I don't know if that means that the hooks is
> > called and by default returns 0 or something. I'm rather confused as the
> > call_int_hook() implies -EOPNOTSUPP is returned but looking at
> > dentry_init_security as defined in LSM_HOOKS(int, 0,
> > dentry_init_security, [...]) in include/linux/lsm_hook_defs.h implies
> > that the default return value is 0.
> 
> Yeah, the problem is the call_int_hook macro, I think, which wants to
> walk through all of the LSMs in the stack and call this for all of
> them.  What happens though if you have 2 entries with valid
> dentry_init_security hooks in them, and they both try to set the xattr
> name?
> 
> This can only ever return a single xattr_name, so maybe the right thing
> to do is to make the default for the LSM_HOOK be -EOPNOTSUPP and add a
> macro that does call_int_hook, but returns after the first supported
> hook call? Something like this maybe? (untested):

[ cc Casey Schaufler <casey@schaufler-ca.com> ]

Actually this patch might work. IIUC, so is the problem happening due
to BPF LSM (CONFIG_BPF_LSM). I see following in bpf_lsm.c

/* For every LSM hook that allows attachment of BPF programs, declare a nop
 * function where a BPF program can be attached.
 */
#define LSM_HOOK(RET, DEFAULT, NAME, ...)       \
noinline RET bpf_lsm_##NAME(__VA_ARGS__)        \
{                                               \
        return DEFAULT;                         \
}

So if CONFIG_BPF_LSM=y, then it will automatically register a hook
for dentry_init_security() and return DEFAULT. I suspect, that what
is happening here and that's how we get return code of 0 and not
-EOPNOTSUPP.

So LSM_HOOK(int, -EOPNOTSUPP, dentry_init_security, ....) should fix
that. 

But you are right that now if both SELINUX and BPF_LSM are enabled 
and in that case we will call both the hooks and call_int_hook()
will not work anymore if BPF LSM hook is called first. It will 
return -EOPNOTSUPP without ever calling into SELinux lsm. So we
need the extra helper which continues to call into next LSM if
previous LSMs returned -EOPNOTSUPP.

This will work as long as BPF LSM always returns -EOPNOTSUPP. I don't
know enough about BPF. But can one write a BPF program and return
something other than -EOPNOTSUPP. In that case it will break.

May be not. I guess if there are multiple LSMs supporting
dentry_init_security() hooks, then intent is to call into first
LSM which does something and initializes security context. If BPF
somehow manages to do that, so it gets that opportunity and SELinux
will not be called.

Having said that, SELinux might not like the idea. 

And if SELinux is called first, then BPF hook will never be called
and any bpf program waiting to be called will be missed. I guess
this is lesser of a problem. First we need to fix ceph crash and
also make sure SELinux context is initialized (even if BPF LSM is
enabled).

Looks like dentry_init_security() can't handle multiple LSMs. We probably
should disallow all other LSMs to register a hook for this and only
allow SELinux to register a hook.

Thanks
Vivek



> 
> -----------8<----------------
> 
> [RFC PATCH] security: dentry_init_security hook should return on first success
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/lsm_hook_defs.h |  2 +-
>  security/security.c           | 18 ++++++++++++++++--
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index a5a724c308d8..819ec92dc2a8 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -80,7 +80,7 @@ LSM_HOOK(int, 0, sb_clone_mnt_opts, const struct super_block *oldsb,
>  	 unsigned long *set_kern_flags)
>  LSM_HOOK(int, 0, move_mount, const struct path *from_path,
>  	 const struct path *to_path)
> -LSM_HOOK(int, 0, dentry_init_security, struct dentry *dentry,
> +LSM_HOOK(int, -EOPNOTSUPP, dentry_init_security, struct dentry *dentry,
>  	 int mode, const struct qstr *name, const char **xattr_name,
>  	 void **ctx, u32 *ctxlen)
>  LSM_HOOK(int, 0, dentry_create_files_as, struct dentry *dentry, int mode,
> diff --git a/security/security.c b/security/security.c
> index 3d4eb474f35b..0133e60f4817 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -745,6 +745,19 @@ static int lsm_superblock_alloc(struct super_block *sb)
>  	RC;							\
>  })
>  
> +#define call_first_supported_int_hook(FUNC, IRC, ...) ({	\
> +	int RC = IRC;						\
> +	do {							\
> +		struct security_hook_list *P;			\
> +								\
> +		hlist_for_each_entry(P, &security_hook_heads.FUNC, list) { \
> +			RC = P->hook.FUNC(__VA_ARGS__);		\
> +			if (RC != -EOPNOTSUPP)			\
> +				break;				\
> +		}						\
> +	} while (0);						\
> +	RC;							\
> +})
>  /* Security operations */
>  
>  int security_binder_set_context_mgr(const struct cred *mgr)
> @@ -1048,8 +1061,9 @@ int security_dentry_init_security(struct dentry *dentry, int mode,
>  				  const char **xattr_name, void **ctx,
>  				  u32 *ctxlen)
>  {
> -	return call_int_hook(dentry_init_security, -EOPNOTSUPP, dentry, mode,
> -				name, xattr_name, ctx, ctxlen);
> +	return call_first_supported_int_hook(dentry_init_security,
> +					     -EOPNOTSUPP, dentry, mode,
> +					     name, xattr_name, ctx, ctxlen);
>  }
>  EXPORT_SYMBOL(security_dentry_init_security);
>  
> -- 
> 2.34.1
> 
> 
> 

