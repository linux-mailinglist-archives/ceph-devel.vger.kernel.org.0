Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA60122360
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Dec 2019 06:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfLQFGj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Dec 2019 00:06:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43679 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725812AbfLQFGi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Dec 2019 00:06:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576559197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EwD8aTiKMQpde6zxFCBNJ/+BmbtVrcTjAf7rYj/9Gsc=;
        b=Otf7rQmHHAVAk4Kd08RjOx1fyCuIl0M3JEf7p/endNr5urhEuNfixRWBpV+Fh0eZT9QVp7
        nmAfL4aQoLWsRZ6LefG/BZtxHenGwQhvmFnVBXQEIn8181yxIsv5lrO79vfG+Vak+ELCNn
        oNnPruqF/7o3AxYRnvgJhBHaruEst24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-OXX9thj3NqSBo8oLa1cn0Q-1; Tue, 17 Dec 2019 00:06:21 -0500
X-MC-Unique: OXX9thj3NqSBo8oLa1cn0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11925800D50;
        Tue, 17 Dec 2019 05:06:20 +0000 (UTC)
Received: from [10.72.12.95] (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C7DA60F88;
        Tue, 17 Dec 2019 05:06:14 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: remove the extra slashes in the server path
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191217050231.3856-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5276643e-9c7b-b135-c638-c51bf53ded8d@redhat.com>
Date:   Tue, 17 Dec 2019 13:06:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191217050231.3856-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Rebase to newest code with new mount API.

The following are the test cases and logs:

# ./bin/mount.ceph :////// /mnt/cephfs/

<7>[=C2=A0 441.397706] ceph: ceph_parse_mount_param fs_parse 'source' tok=
en 12
<7>[=C2=A0 441.397708] ceph:=C2=A0 ceph_parse_source=20
'192.168.195.165:40842,192.168.195.165:40844,192.168.195.165:40846://////=
'
<7>[=C2=A0 441.397709] ceph:=C2=A0 device name=20
'192.168.195.165:40842,192.168.195.165:40844,192.168.195.165:40846'
<7>[=C2=A0 441.397709] ceph:=C2=A0 server path '//////'
<7>[=C2=A0 441.397711] ceph:=C2=A0 ceph_get_tree
<7>[=C2=A0 441.399145] ceph:=C2=A0 set_super 000000009fcb2000
<7>[=C2=A0 441.399156] ceph:=C2=A0 get_sb using new client 00000000599fa1=
53
<7>[=C2=A0 441.401617] ceph:=C2=A0 mount start 00000000599fa153
<6>[=C2=A0 441.405023] libceph: mon1 (1)192.168.195.165:40844 session est=
ablished
<6>[=C2=A0 441.405869] libceph: client4270 fsid=20
9017b7e6-dc32-472b-8ee5-00d5d799e39b
<7>[=C2=A0 441.405917] ceph:=C2=A0 mount opening path ''
<7>[=C2=A0 441.405932] ceph:=C2=A0 open_root_inode opening ''
<7>[=C2=A0 441.412394] ceph:=C2=A0 open_root_inode success
<7>[=C2=A0 441.412402] ceph:=C2=A0 open_root_inode success, root dentry i=
s=20
000000003a823af7
<7>[=C2=A0 441.412404] ceph:=C2=A0 mount success
<7>[=C2=A0 441.412405] ceph:=C2=A0 root 000000003a823af7 inode 0000000030=
01993e=20
ino 1.fffffffffffffffe
<7>[=C2=A0 441.412453] ceph:=C2=A0 destroy_mount_options 000000006a4e278a


# ./bin/mount.ceph :///mydir/// /mnt/cephfs/

<7>[=C2=A0 484.500470] ceph: ceph_parse_mount_param fs_parse 'source' tok=
en 12
<7>[=C2=A0 484.500472] ceph:=C2=A0 ceph_parse_source=20
'192.168.195.165:40842,192.168.195.165:40844,192.168.195.165:40846:///myd=
ir///'
<7>[=C2=A0 484.500473] ceph:=C2=A0 device name=20
'192.168.195.165:40842,192.168.195.165:40844,192.168.195.165:40846'
<7>[=C2=A0 484.500473] ceph:=C2=A0 server path '///mydir///'
<7>[=C2=A0 484.500476] ceph:=C2=A0 ceph_get_tree
<7>[=C2=A0 484.501103] ceph:=C2=A0 ceph_compare_super 000000009fcb2000
<7>[=C2=A0 484.501105] ceph:=C2=A0 monitor(s)/mount options don't match
<7>[=C2=A0 484.501123] ceph:=C2=A0 ceph_compare_super 000000009fcb2000
<7>[=C2=A0 484.501124] ceph:=C2=A0 monitor(s)/mount options don't match
<7>[=C2=A0 484.501124] ceph:=C2=A0 set_super 00000000ecb2f6a5
<7>[=C2=A0 484.501127] ceph:=C2=A0 get_sb using new client 0000000050771e=
07
<7>[=C2=A0 484.501178] ceph:=C2=A0 mount start 0000000050771e07
<6>[=C2=A0 484.506726] libceph: mon0 (1)192.168.195.165:40842 session est=
ablished
<6>[=C2=A0 484.510481] libceph: client4278 fsid=20
9017b7e6-dc32-472b-8ee5-00d5d799e39b
<7>[=C2=A0 484.510656] ceph:=C2=A0 mount opening path 'mydir'
<7>[=C2=A0 484.510681] ceph:=C2=A0 open_root_inode opening 'mydir'
<7>[=C2=A0 484.519966] ceph:=C2=A0 open_root_inode success
<7>[=C2=A0 484.519970] ceph:=C2=A0 open_root_inode success, root dentry i=
s=20
0000000009d7f53d
<7>[=C2=A0 484.519972] ceph:=C2=A0 mount success
<7>[=C2=A0 484.519973] ceph:=C2=A0 root 0000000009d7f53d inode 0000000008=
1d2db7=20
ino 10000000000.fffffffffffffffe
<7>[=C2=A0 484.520030] ceph:=C2=A0 destroy_mount_options 000000006a4e278a





On 2019/12/17 13:02, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> When mounting if the server path has more than one slash continously,
> such as:
>
> 'mount.ceph 192.168.195.165:40176:/// /mnt/cephfs/'
>
> In the MDS server side the extra slashes of the server path will be
> treated as snap dir, and then we can get the following debug logs:
>
> <7>[  ...] ceph:  mount opening path //
> <7>[  ...] ceph:  open_root_inode opening '//'
> <7>[  ...] ceph:  fill_trace 0000000059b8a3bc is_dentry 0 is_target 1
> <7>[  ...] ceph:  alloc_inode 00000000dc4ca00b
> <7>[  ...] ceph:  get_inode created new inode 00000000dc4ca00b 1.ffffff=
ffffffffff ino 1
> <7>[  ...] ceph:  get_inode on 1=3D1.ffffffffffffffff got 00000000dc4ca=
00b
>
> And then when creating any new file or directory under the mount
> point, we can get the following crash core dump:
>
> <4>[  ...] ------------[ cut here ]------------
> <2>[  ...] kernel BUG at fs/ceph/inode.c:1347!
> <4>[  ...] invalid opcode: 0000 [#1] SMP PTI
> <4>[  ...] CPU: 0 PID: 7 Comm: kworker/0:1 Tainted: G            E     =
5.4.0-rc5+ #1
> <4>[  ...] Hardware name: VMware, Inc. VMware Virtual Platform/440BX De=
sktop Reference Platform, BIOS 6.00 05/19/2017
> <4>[  ...] Workqueue: ceph-msgr ceph_con_workfn [libceph]
> <4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
> <4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 4d [...]
> <4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
> <4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 00000000000=
00006
> <4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec=
17900
> <4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 00000000000=
00885
> <4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a23934=
7e000
> <4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b=
0c900
> <4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:=
0000000000000000
> <4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 00000000003=
606f0
> <4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
> <4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
> <4>[  ...] Call Trace:
> <4>[  ...]  dispatch+0x2ac/0x12b0 [ceph]
> <4>[  ...]  ceph_con_workfn+0xd40/0x27c0 [libceph]
> <4>[  ...]  process_one_work+0x1b0/0x350
> <4>[  ...]  worker_thread+0x50/0x3b0
> <4>[  ...]  kthread+0xfb/0x130
> <4>[  ...]  ? process_one_work+0x350/0x350
> <4>[  ...]  ? kthread_park+0x90/0x90
> <4>[  ...]  ret_from_fork+0x35/0x40
> <4>[  ...] Modules linked in: ceph(E) libceph fscache [...]
> <4>[  ...] ---[ end trace ba883d8ccf9afcb0 ]---
> <4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
> <4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 [...]
> <4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
> <4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 00000000000=
00006
> <4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec=
17900
> <4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 00000000000=
00885
> <4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a23934=
7e000
> <4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b=
0c900
> <4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:=
0000000000000000
> <4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 00000000003=
606f0
> <4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
> <4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
>
> And we should ignore the extra slashes in the server path when mount
> opening in case users have added them by mistake.
>
> This will also help us to get an existing superblock if all the
> other options are the same, such as all the following server paths
> are treated as the same:
>
> 1) "//mydir1///mydir//"
> 2) "/mydir1/mydir"
> 3) "/mydir1/mydir/"
>
> The mount_options->server_path will always save the original string
> including the leading '/'.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/super.c | 108 +++++++++++++++++++++++++++++++++++++++++------=
-
>   1 file changed, 93 insertions(+), 15 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 6f33a265ccf1..9fe1bfac66a2 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -211,7 +211,6 @@ struct ceph_parse_opts_ctx {
>  =20
>   /*
>    * Parse the source parameter.  Distinguish the server list from the =
path.
> - * Internally we do not include the leading '/' in the path.
>    *
>    * The source will look like:
>    *     <server_spec>[,<server_spec>...]:[<path>]
> @@ -232,12 +231,15 @@ static int ceph_parse_source(struct fs_parameter =
*param, struct fs_context *fc)
>  =20
>   	dev_name_end =3D strchr(dev_name, '/');
>   	if (dev_name_end) {
> -		if (strlen(dev_name_end) > 1) {
> -			kfree(fsopt->server_path);
> -			fsopt->server_path =3D kstrdup(dev_name_end, GFP_KERNEL);
> -			if (!fsopt->server_path)
> -				return -ENOMEM;
> -		}
> +		kfree(fsopt->server_path);
> +
> +		/*
> +		 * The server_path will include the whole chars from userland
> +		 * including the leading '/'.
> +		 */
> +		fsopt->server_path =3D kstrdup(dev_name_end, GFP_KERNEL);
> +		if (!fsopt->server_path)
> +			return -ENOMEM;
>   	} else {
>   		dev_name_end =3D dev_name + strlen(dev_name);
>   	}
> @@ -459,6 +461,64 @@ static int strcmp_null(const char *s1, const char =
*s2)
>   	return strcmp(s1, s2);
>   }
>  =20
> +/**
> + * path_remove_extra_slash - Remove the extra slashes in the server pa=
th
> + * @server_path: the server path and could be NULL
> + *
> + * Return NULL if the path is NULL or only consists of "/", or a strin=
g
> + * without any extra slashes including the leading slash(es) and the
> + * slash(es) at the end of the server path, such as:
> + * "//dir1////dir2///" --> "dir1/dir2"
> + */
> +static char *path_remove_extra_slash(const char *server_path)
> +{
> +	const char *path =3D server_path;
> +	bool last_is_slash;
> +	int i, j, len;
> +	char *p;
> +
> +	/* if the server path is omitted */
> +	if (!path)
> +		return NULL;
> +
> +	/* remove all the leading slashes */
> +	while (*path =3D=3D '/')
> +		path++;
> +
> +	/* if the server path only consists of slashes */
> +	if (*path =3D=3D '\0')
> +		return NULL;
> +
> +	len =3D strlen(path);
> +
> +	p =3D kmalloc(len, GFP_KERNEL);
> +	if (!p)
> +		return ERR_PTR(-ENOMEM);
> +
> +	last_is_slash =3D false;
> +	for (j =3D 0, i =3D 0; i < len; i++) {
> +		if (path[i] =3D=3D '/') {
> +			if (last_is_slash)
> +				continue;
> +			last_is_slash =3D true;
> +		} else {
> +			last_is_slash =3D false;
> +		}
> +		p[j++] =3D path[i];
> +	}
> +
> +	/*
> +	 * remove the last slash if there has just to make sure that
> +	 * we will get "dir1/dir2"
> +	 */
> +	if (p[j - 1] =3D=3D '/')
> +		j--;
> +
> +	p[j] =3D '\0';
> +
> +	return p;
> +}
> +
>   static int compare_mount_options(struct ceph_mount_options *new_fsopt=
,
>   				 struct ceph_options *new_opt,
>   				 struct ceph_fs_client *fsc)
> @@ -466,6 +526,7 @@ static int compare_mount_options(struct ceph_mount_=
options *new_fsopt,
>   	struct ceph_mount_options *fsopt1 =3D new_fsopt;
>   	struct ceph_mount_options *fsopt2 =3D fsc->mount_options;
>   	int ofs =3D offsetof(struct ceph_mount_options, snapdir_name);
> +	char *p1, *p2;
>   	int ret;
>  =20
>   	ret =3D memcmp(fsopt1, fsopt2, ofs);
> @@ -478,9 +539,21 @@ static int compare_mount_options(struct ceph_mount=
_options *new_fsopt,
>   	ret =3D strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
>   	if (ret)
>   		return ret;
> -	ret =3D strcmp_null(fsopt1->server_path, fsopt2->server_path);
> +
> +	p1 =3D path_remove_extra_slash(fsopt1->server_path);
> +	if (IS_ERR(p1))
> +		return PTR_ERR(p1);
> +	p2 =3D path_remove_extra_slash(fsopt2->server_path);
> +	if (IS_ERR(p2)) {
> +		kfree(p1);
> +		return PTR_ERR(p2);
> +	}
> +	ret =3D strcmp_null(p1, p2);
> +	kfree(p1);
> +	kfree(p2);
>   	if (ret)
>   		return ret;
> +
>   	ret =3D strcmp_null(fsopt1->fscache_uniq, fsopt2->fscache_uniq);
>   	if (ret)
>   		return ret;
> @@ -883,7 +956,7 @@ static struct dentry *ceph_real_mount(struct ceph_f=
s_client *fsc,
>   	mutex_lock(&fsc->client->mount_mutex);
>  =20
>   	if (!fsc->sb->s_root) {
> -		const char *path;
> +		const char *path, *p;
>   		err =3D __ceph_open_session(fsc->client, started);
>   		if (err < 0)
>   			goto out;
> @@ -895,17 +968,22 @@ static struct dentry *ceph_real_mount(struct ceph=
_fs_client *fsc,
>   				goto out;
>   		}
>  =20
> -		if (!fsc->mount_options->server_path) {
> -			path =3D "";
> -			dout("mount opening path \\t\n");
> -		} else {
> -			path =3D fsc->mount_options->server_path + 1;
> -			dout("mount opening path %s\n", path);
> +		p =3D path_remove_extra_slash(fsc->mount_options->server_path);
> +		if (IS_ERR(p)) {
> +			err =3D PTR_ERR(p);
> +			goto out;
>   		}
> +		/* if the server path is omitted or just consists of '/' */
> +		if (!p)
> +			path =3D "";
> +		else
> +			path =3D p;
> +		dout("mount opening path '%s'\n", path);
>  =20
>   		ceph_fs_debugfs_init(fsc);
>  =20
>   		root =3D open_root_dentry(fsc, path, started);
> +		kfree(p);
>   		if (IS_ERR(root)) {
>   			err =3D PTR_ERR(root);
>   			goto out;


