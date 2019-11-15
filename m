Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A47FD275
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2019 02:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKOBbz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 20:31:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54289 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726996AbfKOBbz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 20:31:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573781513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qNEccuAdVAsWcPvGbLp8MMvfTrYlHF1nOIzgxIyIkzk=;
        b=A2oWhIT5BNANa6dsh+knJjjO9SZfaoN9RKoKQhhnzSHOojwgjPnpaMRKJoRtl/TQl9XAgL
        ZCnzyDG/Kun8Wn2HR/g+H4iPtRCvSFYCAIk8uuCi7IHPMUt7MABn/uVILMcV5KNZlXT6VD
        HIVTXAGmHVahzC3SdJ2yKrTa6tvwq+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346--uCa_KylP9qcnnf4kf571g-1; Thu, 14 Nov 2019 20:31:50 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 299E3802680;
        Fri, 15 Nov 2019 01:31:49 +0000 (UTC)
Received: from [10.72.12.58] (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABF9960BF7;
        Fri, 15 Nov 2019 01:31:43 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: remove the extra slashes in the server path
To:     Jeff Layton <jlayton@kernel.org>, sage@redhat.com,
        idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20191114023719.25316-1-xiubli@redhat.com>
 <d92dfa711410cdef2b6f9f0dc0a0c86ad263844c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <bda09cc5-2e5d-8942-3fb0-2bc2e642d621@redhat.com>
Date:   Fri, 15 Nov 2019 09:31:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <d92dfa711410cdef2b6f9f0dc0a0c86ad263844c.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: -uCa_KylP9qcnnf4kf571g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add the ceph-devel in this thread, sorry to missing it.

On 2019/11/14 19:34, Jeff Layton wrote:
> On Wed, 2019-11-13 at 21:37 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
> Any reason not to cc ceph-devel here? Was that just an oversight, or do
> you think this needs a security embargo?

Sorry, just pressed the button and post it by mistake without the=20
ceph-devel list, and I had post it again just after this with the list=20
yesterday.


>> When mounting if the server path has more than one slash, such as:
>>
>> 'mount.ceph 192.168.195.165:40176:/// /mnt/cephfs/'
>>
>> In the MDS server side the extra slash will be treated as snap dir,
>> and then we can get the following debug logs:
>>
> It sort of sounds like the real problem is in the MDS.
>
> Shouldn't it just be ignoring the extra '/' characters? I'm not a huge
> fan of adding in this complex handling to work around an MDS bug.

Yeah, the MDS is buggy too and I will try to fix it later.

But here in the kclient IMO we still need to ignore the extra slashes in=20
case that if some one want to do or by type mistake:

1, 'mount.ceph 192.168.195.165:40176:/mydir/=C2=A0=C2=A0 /mnt/cephfs/'

2, 'mount.ceph 192.168.195.165:40176:/mydir//=C2=A0=C2=A0 /mnt/cephfs/'

or

1, 'mount.ceph 192.168.195.165:40176:/mydir/ =C2=A0 /mnt/cephfs/'

2, 'mount.ceph 192.168.195.165:40176://mydir=C2=A0=C2=A0 /mnt/cephfs/'

Both pairs above should be the same in theory, but when running the=20
Step2 and comparing and searching a existing same sb, it will fail and=20
then create a new one. The code like:

ceph_mount()-->sget() --> ceph_compare_super() --> compare_mount_options()=
=EF=BC=9A

ret =3D strcmp_null(fsopt1->server_path, fsopt2->server_path);

Currently the server_paths here will only remove the leading slash in=20
the server paths just before mount opening.

With this fix we can do nothing for the Step2 and just return with:

"mount error 16 =3D Device or resource busy"


>> <7>[  ...] ceph:  mount opening path //
>> <7>[  ...] ceph:  open_root_inode opening '//'
>> <7>[  ...] ceph:  fill_trace 0000000059b8a3bc is_dentry 0 is_target 1
>> <7>[  ...] ceph:  alloc_inode 00000000dc4ca00b
>> <7>[  ...] ceph:  get_inode created new inode 00000000dc4ca00b 1.fffffff=
fffffffff ino 1
>> <7>[  ...] ceph:  get_inode on 1=3D1.ffffffffffffffff got 00000000dc4ca0=
0b
>>
>> And then when creating any new file or directory under the mount
>> point, we can get the following crash core dump:
>>
>> <4>[  ...] ------------[ cut here ]------------
>> <2>[  ...] kernel BUG at fs/ceph/inode.c:1347!
> Which BUG_ON is this? I'd guess one of these, but it'd be good to
> confirm it:
>
>                  BUG_ON(ceph_ino(dir) !=3D dvino.ino);
>                  BUG_ON(ceph_snap(dir) !=3D dvino.snap);
>  =20

Yeah, It is the second one and the bug is:

https://tracker.ceph.com/issues/42771


>> <4>[  ...] invalid opcode: 0000 [#1] SMP PTI
>> <4>[  ...] CPU: 0 PID: 7 Comm: kworker/0:1 Tainted: G            E     5=
.4.0-rc5+ #1
>> <4>[  ...] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Des=
ktop Reference Platform, BIOS 6.00 05/19/2017
>> <4>[  ...] Workqueue: ceph-msgr ceph_con_workfn [libceph]
>> <4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
>> <4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 4d [...]
>> <4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
>> <4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 000000000000=
0006
>> <4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec1=
7900
>> <4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 000000000000=
0885
>> <4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a239347=
e000
>> <4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b0=
c900
>> <4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:0=
000000000000000
>> <4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> <4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 000000000036=
06f0
>> <4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000=
0000
>> <4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000000=
0400
>> <4>[  ...] Call Trace:
>> <4>[  ...]  dispatch+0x2ac/0x12b0 [ceph]
>> <4>[  ...]  ceph_con_workfn+0xd40/0x27c0 [libceph]
>> <4>[  ...]  process_one_work+0x1b0/0x350
>> <4>[  ...]  worker_thread+0x50/0x3b0
>> <4>[  ...]  kthread+0xfb/0x130
>> <4>[  ...]  ? process_one_work+0x350/0x350
>> <4>[  ...]  ? kthread_park+0x90/0x90
>> <4>[  ...]  ret_from_fork+0x35/0x40
>> <4>[  ...] Modules linked in: ceph(E) libceph fscache [...]
>> <4>[  ...] ---[ end trace ba883d8ccf9afcb0 ]---
>> <4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
>> <4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 [...]
>> <4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
>> <4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 000000000000=
0006
>> <4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec1=
7900
>> <4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 000000000000=
0885
>> <4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a239347=
e000
>> <4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b0=
c900
>> <4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:0=
000000000000000
>> <4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> <4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 000000000036=
06f0
>> <4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000=
0000
>> <4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000000=
0400
>>
>> And we should ignore the extra slashes in the server path when mount
>> opening in case users have added them by mistake:
>>
>> "//mydir1///mydir//" --> "mydir1/mydir/"
>>
> Shouldn't that be:
>
>      "//mydir1///mydir//" --> "/mydir1/mydir/"
>
> Why strip off all of the leading slashes?

There is one old commit From Yan, Zheng:

commit ce2728aaa82bbebae7d20345324af3f0f49eeb20
Author: Yan, Zheng <zyan@redhat.com>
Date:=C2=A0=C2=A0 Wed Sep 14 14:53:05 2016 +0800

 =C2=A0=C2=A0=C2=A0 ceph: avoid accessing / when mounting a subpath

 =C2=A0=C2=A0=C2=A0 Accessing / causes failuire if the client has caps that=
 restrict path

 =C2=A0=C2=A0=C2=A0 Signed-off-by: Yan, Zheng <zyan@redhat.com>

This will remove the leading '/' when mount opening.


>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/super.c | 71 ++++++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 61 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index b47f43fc2d68..91985c53e611 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -430,6 +430,39 @@ static int strcmp_null(const char *s1, const char *=
s2)
>>   =09return strcmp(s1, s2);
>>   }
>>  =20
>> +static char *path_remove_extra_slash(const char *path)
>> +{
>> +=09bool last_is_slash;
>> +=09int i, j;
>> +=09int len;
>> +=09char *p;
>> +
>> +=09if (!path)
>> +=09=09return NULL;
>> +
>> +=09len =3D strlen(path);
>> +
>> +=09p =3D kmalloc(len, GFP_NOFS);
>> +=09if (!p)
>> +=09=09return ERR_PTR(-ENOMEM);
>> +
> Given that this should only be called when mounting, you can probably
> use GFP_KERNEL here.

Yeah, will fix it.

BRs

Xiubo


>> +=09last_is_slash =3D false;
>> +=09for (j =3D 0, i =3D 0; i < len; i++) {
>> +=09=09if (path[i] =3D=3D '/') {
>> +=09=09=09if (last_is_slash)
>> +=09=09=09=09continue;
>> +=09=09=09last_is_slash =3D true;
>> +=09=09} else {
>> +=09=09=09last_is_slash =3D false;
>> +=09=09}
>> +=09=09p[j++] =3D path[i];
>> +=09}
>> +
>> +=09p[j] =3D '\0';
>> +
>> +=09return p;
>> +}
>> +
>>   static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>>   =09=09=09=09 struct ceph_options *new_opt,
>>   =09=09=09=09 struct ceph_fs_client *fsc)
>> @@ -437,6 +470,7 @@ static int compare_mount_options(struct ceph_mount_o=
ptions *new_fsopt,
>>   =09struct ceph_mount_options *fsopt1 =3D new_fsopt;
>>   =09struct ceph_mount_options *fsopt2 =3D fsc->mount_options;
>>   =09int ofs =3D offsetof(struct ceph_mount_options, snapdir_name);
>> +=09char *p1, *p2;
>>   =09int ret;
>>  =20
>>   =09ret =3D memcmp(fsopt1, fsopt2, ofs);
>> @@ -449,9 +483,21 @@ static int compare_mount_options(struct ceph_mount_=
options *new_fsopt,
>>   =09ret =3D strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
>>   =09if (ret)
>>   =09=09return ret;
>> -=09ret =3D strcmp_null(fsopt1->server_path, fsopt2->server_path);
>> +
>> +=09p1 =3D path_remove_extra_slash(fsopt1->server_path);
>> +=09if (IS_ERR(p1))
>> +=09=09return PTR_ERR(p1);
>> +=09p2 =3D path_remove_extra_slash(fsopt2->server_path);
>> +=09if (IS_ERR(p2)) {
>> +=09=09kfree(p1);
>> +=09=09return PTR_ERR(p2);
>> +=09}
>> +=09ret =3D strcmp_null(p1, p2);
>> +=09kfree(p1);
>> +=09kfree(p2);
>>   =09if (ret)
>>   =09=09return ret;
>> +
>>   =09ret =3D strcmp_null(fsopt1->fscache_uniq, fsopt2->fscache_uniq);
>>   =09if (ret)
>>   =09=09return ret;
>> @@ -507,12 +553,10 @@ static int parse_mount_options(struct ceph_mount_o=
ptions **pfsopt,
>>   =09 */
>>   =09dev_name_end =3D strchr(dev_name, '/');
>>   =09if (dev_name_end) {
>> -=09=09if (strlen(dev_name_end) > 1) {
>> -=09=09=09fsopt->server_path =3D kstrdup(dev_name_end, GFP_KERNEL);
>> -=09=09=09if (!fsopt->server_path) {
>> -=09=09=09=09err =3D -ENOMEM;
>> -=09=09=09=09goto out;
>> -=09=09=09}
>> +=09=09fsopt->server_path =3D kstrdup(dev_name_end, GFP_KERNEL);
>> +=09=09if (!fsopt->server_path) {
>> +=09=09=09err =3D -ENOMEM;
>> +=09=09=09goto out;
>>   =09=09}
>>   =09} else {
>>   =09=09dev_name_end =3D dev_name + strlen(dev_name);
>> @@ -945,7 +989,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs=
_client *fsc)
>>   =09mutex_lock(&fsc->client->mount_mutex);
>>  =20
>>   =09if (!fsc->sb->s_root) {
>> -=09=09const char *path;
>> +=09=09const char *path, *p;
>>   =09=09err =3D __ceph_open_session(fsc->client, started);
>>   =09=09if (err < 0)
>>   =09=09=09goto out;
>> @@ -957,17 +1001,24 @@ static struct dentry *ceph_real_mount(struct ceph=
_fs_client *fsc)
>>   =09=09=09=09goto out;
>>   =09=09}
>>  =20
>> -=09=09if (!fsc->mount_options->server_path) {
>> +=09=09p =3D path_remove_extra_slash(fsc->mount_options->server_path);
>> +=09=09if (IS_ERR(p)) {
>> +=09=09=09err =3D PTR_ERR(p);
>> +=09=09=09goto out;
>> +=09=09}
>> +=09=09/* if the server path is omitted in the dev_name or just '/' */
>> +=09=09if (!p || (p && strlen(p) =3D=3D 1)) {
>>   =09=09=09path =3D "";
>>   =09=09=09dout("mount opening path \\t\n");
>>   =09=09} else {
>> -=09=09=09path =3D fsc->mount_options->server_path + 1;
>> +=09=09=09path =3D p + 1;
>>   =09=09=09dout("mount opening path %s\n", path);
>>   =09=09}
>>  =20
>>   =09=09ceph_fs_debugfs_init(fsc);
>>  =20
>>   =09=09root =3D open_root_dentry(fsc, path, started);
>> +=09=09kfree(p);
>>   =09=09if (IS_ERR(root)) {
>>   =09=09=09err =3D PTR_ERR(root);
>>   =09=09=09goto out;


