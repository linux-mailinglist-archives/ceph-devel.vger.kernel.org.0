Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09C949C01F
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 01:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiAZA1p (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 19:27:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229516AbiAZA1o (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 19:27:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643156864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PsO5WDnUxHwbAh4QypMf2Eriq39K7EEY1iQPfrC7GTM=;
        b=goxT0ap2ZZb3QNB7D40/glBanNGrqV8SbAfwfqc3YuJXUY18h5703rRdGR5uDRohgzkMCZ
        fah9hcgSel+wRMDyLh18bkpbrqGj3dEfzEhL1cZKv2OkOfu7FdA7agrZG7FQd5RV4q6+iB
        2KA0wYUadSLQ/bVPJBo5nGXicltNCEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-3gxLkq6_PS21eoYDOIB0QQ-1; Tue, 25 Jan 2022 19:27:40 -0500
X-MC-Unique: 3gxLkq6_PS21eoYDOIB0QQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 230E0814243;
        Wed, 26 Jan 2022 00:27:39 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.9.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 991C74ABA6;
        Wed, 26 Jan 2022 00:27:38 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 2DA43223DA6; Tue, 25 Jan 2022 19:27:38 -0500 (EST)
Date:   Tue, 25 Jan 2022 19:27:38 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Stephen Muth <smuth4@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-security-module@vger.kernel.org
Subject: Re: "kernel NULL pointer dereference" crash when attempting a write
Message-ID: <YfCVesVeB0V++tok@redhat.com>
References: <CAM2jsSiHK_++SggmRyRbCxZ58hywxeZsJJMJHpQfbAz-5AfJ0g@mail.gmail.com>
 <CAHC9VhR1efuTR_zLLhmOyS4EHT1oHgA1d_StooKXmFf9WGODyA@mail.gmail.com>
 <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
 <20220125111350.t2jgmqdvshgr7doi@wittgenstein>
 <d5490a7c87b8c435b3c7bdb8d2c8edef2c2a576a.camel@kernel.org>
 <20220125121213.ontt4fide32phuzl@wittgenstein>
 <ab92b28e953601785467cdf8ca67dd5b0ef55105.camel@kernel.org>
 <YfAdtAaUfz38xtmf@redhat.com>
 <2f1c3741-df38-1179-5e3f-4cd1c4516e76@schaufler-ca.com>
 <CAHC9VhRgKZDzyNOhd-0nmKxBdnzQW5FHRwg9hHjGrUEPMhqaDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRgKZDzyNOhd-0nmKxBdnzQW5FHRwg9hHjGrUEPMhqaDg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 02:57:46PM -0500, Paul Moore wrote:
> 
> > > Looks like dentry_init_security() can't handle multiple LSMs. We probably
> > > should disallow all other LSMs to register a hook for this and only
> > > allow SELinux to register a hook.
> >
> > Not acceptable. The fix to dentry_init_security() is easy.
> 
> Sounds good to me, Vivek did you want to put together a patch for
> this?  If not, let me know and I'll put one together.

Ok, I have put together this test patch. Stephen Muth, can you please
test it and let us know if it solves your problem.

I enabled CONFIG_BPF_LSM=y but that itself does not seem to be sufficient
for BPF to register a hook for dentry_init_security. So I don't see
it being called in my testing. IOW, I have not been able to reproduce
the issue and will rely on testing from Stephen to know if it it indeed
solved the problem for him or not.

-------------------8<--------------------

Subject: lsm: dentry_init_security(): Deal with multiple LSMs registering hook

A ceph user has reported that ceph is crashing with kernel NULL pointer
dereference. Following is backtrace.

/proc/version: Linux version 5.16.2-arch1-1 (linux@archlinux) (gcc (GCC)
11.1.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Thu, 20 Jan 2022
16:18:29 +0000
distro / arch: Arch Linux / x86_64
SELinux is not enabled
ceph cluster version: 16.2.7 (dd0603118f56ab514f133c8d2e3adfc983942503)

relevant dmesg output:
[   30.947129] BUG: kernel NULL pointer dereference, address:
0000000000000000
[   30.947206] #PF: supervisor read access in kernel mode
[   30.947258] #PF: error_code(0x0000) - not-present page
[   30.947310] PGD 0 P4D 0
[   30.947342] Oops: 0000 [#1] PREEMPT SMP PTI
[   30.947388] CPU: 5 PID: 778 Comm: touch Not tainted 5.16.2-arch1-1 #1
86fbf2c313cc37a553d65deb81d98e9dcc2a3659
[   30.947486] Hardware name: Gigabyte Technology Co., Ltd. B365M
DS3H/B365M DS3H, BIOS F5 08/13/2019
[   30.947569] RIP: 0010:strlen+0x0/0x20
[   30.947616] Code: b6 07 38 d0 74 16 48 83 c7 01 84 c0 74 05 48 39 f7 75
ec 31 c0 31 d2 89 d6 89 d7 c3 48 89 f8 31 d2 89 d6 89 d7 c3 0
f 1f 40 00 <80> 3f 00 74 12 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 31
ff
[   30.947782] RSP: 0018:ffffa4ed80ffbbb8 EFLAGS: 00010246
[   30.947836] RAX: 0000000000000000 RBX: ffffa4ed80ffbc60 RCX:
0000000000000000
[   30.947904] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[   30.947971] RBP: ffff94b0d15c0ae0 R08: 0000000000000000 R09:
0000000000000000
[   30.948040] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[   30.948106] R13: 0000000000000001 R14: ffffa4ed80ffbc60 R15:
0000000000000000
[   30.948174] FS:  00007fc7520f0740(0000) GS:ffff94b7ced40000(0000)
knlGS:0000000000000000
[   30.948252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   30.948308] CR2: 0000000000000000 CR3: 0000000104a40001 CR4:
00000000003706e0
[   30.948376] Call Trace:
[   30.948404]  <TASK>
[   30.948431]  ceph_security_init_secctx+0x7b/0x240 [ceph
49f9c4b9bf5be8760f19f1747e26da33920bce4b]
[   30.948582]  ceph_atomic_open+0x51e/0x8a0 [ceph
49f9c4b9bf5be8760f19f1747e26da33920bce4b]
[   30.948708]  ? get_cached_acl+0x4d/0xa0
[   30.948759]  path_openat+0x60d/0x1030
[   30.948809]  do_filp_open+0xa5/0x150
[   30.948859]  do_sys_openat2+0xc4/0x190
[   30.948904]  __x64_sys_openat+0x53/0xa0
[   30.948948]  do_syscall_64+0x5c/0x90
[   30.948989]  ? exc_page_fault+0x72/0x180
[   30.949034]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   30.949091] RIP: 0033:0x7fc7521e25bb
[   30.950849] Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00
00 00 85 c0 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 0
0 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 91 00 00 00 48 8b 54 24 28 64 48 2b 14
25

Core of the problem is that ceph checks for return code from
security_dentry_init_security() and if return code is 0, it assumes
everything is fine and continues to call strlen(name), which crashes.

Typically SELinux LSM returns 0 and sets name to "security.selinux" and
it is not a problem. Or if selinux is not compiled in or disabled, it
returns -EOPNOTSUP and ceph deals with it.

But somehow in this configuration, 0 is being returned and "name" is
not being initialized, and that's creating the problem.

Our suspicion is that BPF LSM is registering a hook for
dentry_init_security() and returns hook default of 0. I have not been
able to configure it that way so I am not 100% sure.

LSM_HOOK(int, 0, dentry_init_security, struct dentry *dentry,...)

dentry_init_security() is written in such a way that it expects only one
LSM to register the hook. Atleast that's the expectation with current code.

If another LSM returns a hook and returns default, it will simply return
0 as of now and that will break ceph. 

Anyway, suggestion is that change semantics of this hook a bit. If there
are no LSMs or no LSM is taking ownership and initializing security context,
then return -EOPNOTSUP. Also allow at max one LSM to initialize security
context. This hook can't deal with multiple LSMs trying to init security
context. This patch implements this new behavior.

Reported-by: Stephen Muth <smuth4@gmail.com>
Suggested-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Yet-to-by-Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/lsm_hook_defs.h |    2 +-
 security/security.c           |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

Index: redhat-linux/include/linux/lsm_hook_defs.h
===================================================================
--- redhat-linux.orig/include/linux/lsm_hook_defs.h	2022-01-24 14:56:14.338030140 -0500
+++ redhat-linux/include/linux/lsm_hook_defs.h	2022-01-25 18:48:46.917496696 -0500
@@ -80,7 +80,7 @@ LSM_HOOK(int, 0, sb_clone_mnt_opts, cons
 	 unsigned long *set_kern_flags)
 LSM_HOOK(int, 0, move_mount, const struct path *from_path,
 	 const struct path *to_path)
-LSM_HOOK(int, 0, dentry_init_security, struct dentry *dentry,
+LSM_HOOK(int, -EOPNOTSUPP, dentry_init_security, struct dentry *dentry,
 	 int mode, const struct qstr *name, const char **xattr_name,
 	 void **ctx, u32 *ctxlen)
 LSM_HOOK(int, 0, dentry_create_files_as, struct dentry *dentry, int mode,
Index: redhat-linux/security/security.c
===================================================================
--- redhat-linux.orig/security/security.c	2022-01-25 18:46:59.166496696 -0500
+++ redhat-linux/security/security.c	2022-01-25 18:56:25.251496696 -0500
@@ -1048,8 +1048,19 @@ int security_dentry_init_security(struct
 				  const char **xattr_name, void **ctx,
 				  u32 *ctxlen)
 {
-	return call_int_hook(dentry_init_security, -EOPNOTSUPP, dentry, mode,
-				name, xattr_name, ctx, ctxlen);
+	struct security_hook_list *hp;
+	int rc;
+
+	/*
+	 * Only one module will provide a security context.
+	 */
+	hlist_for_each_entry(hp, &security_hook_heads.dentry_init_security, list) {
+		rc = hp->hook.dentry_init_security(dentry, mode, name,
+						   xattr_name, ctx, ctxlen);
+		if (rc != LSM_RET_DEFAULT(dentry_init_security))
+			return rc;
+	}
+	return LSM_RET_DEFAULT(dentry_init_security);
 }
 EXPORT_SYMBOL(security_dentry_init_security);
 

