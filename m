Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C829F650A59
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Dec 2022 11:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiLSKtK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Dec 2022 05:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiLSKtI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Dec 2022 05:49:08 -0500
Received: from amailer.gwdg.de (amailer.gwdg.de [134.76.10.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892E49586
        for <ceph-devel@vger.kernel.org>; Mon, 19 Dec 2022 02:49:05 -0800 (PST)
Received: from a1235.mx.srv.dfn.de ([194.95.232.117])
        by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (GWDG Mailer)
        (envelope-from <marco.roose@mpinat.mpg.de>)
        id 1p7Dhf-0008cK-Gd; Mon, 19 Dec 2022 11:49:03 +0100
Received: from mailer-b3.gwdg.de (mailer-b3.gwdg.de [134.76.10.19])
        by a1235.mx.srv.dfn.de (Postfix) with ESMTPS id E0C732E003A;
        Mon, 19 Dec 2022 11:49:00 +0100 (CET)
Received: from excmbx-03.um.gwdg.de ([134.76.9.218] helo=email.gwdg.de)
        by mailer.gwdg.de with esmtp (GWDG Mailer)
        (envelope-from <marco.roose@mpinat.mpg.de>)
        id 1p7Dhc-0008Pi-JB; Mon, 19 Dec 2022 11:49:00 +0100
Received: from EXCMBX-13.um.gwdg.de (134.76.9.222) by EXCMBX-03.um.gwdg.de
 (134.76.9.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.16; Mon, 19
 Dec 2022 11:48:56 +0100
Received: from EXCMBX-13.um.gwdg.de ([134.76.9.222]) by EXCMBX-13.um.gwdg.de
 ([134.76.9.222]) with mapi id 15.01.2507.016; Mon, 19 Dec 2022 11:48:55 +0100
From:   "Roose, Marco" <marco.roose@mpinat.mpg.de>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
CC:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Menzel, Paul" <pmenzel@molgen.mpg.de>
Subject: RE: PROBLEM: CephFS write performance drops by 90%
Thread-Topic: PROBLEM: CephFS write performance drops by 90%
Thread-Index: AQHZEI/jaNUzK8v7qUq0BA8NpF//va5vAyEAgAC0/gCAAKFacIAD8tGAgADBBRA=
Date:   Mon, 19 Dec 2022 10:48:55 +0000
Message-ID: <62582bb6b2124f1a9dd111f29049b25b@mpinat.mpg.de>
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
 <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com>
 <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
 <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com>
In-Reply-To: <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.250.9.205]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=SHA1; boundary="----=_NextPart_000_00FF_01D9139F.DF618BA0"
MIME-Version: 1.0
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

------=_NextPart_000_00FF_01D9139F.DF618BA0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Dear Xiubo,
my colleague Paul (in CC) tried to revert the commit, but it was'nt
possible.

Kind regards,
Marco Roose

-----Original Message-----
From: Xiubo Li <xiubli@redhat.com>=20
Sent: 19 December 2022 01:16
To: Roose, Marco <marco.roose@mpinat.mpg.de>; Ilya Dryomov
<idryomov@gmail.com>
Cc: Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: PROBLEM: CephFS write performance drops by 90%


On 16/12/2022 19:37, Roose, Marco wrote:
> Hi Ilya and Xiubo,
> thanks for looking onto this. I try to answer you questions:
>
> =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>> What is the workload / test case?
> I'm using a ~ 2G large test file which I rsync from local storage to=20
> the ceph mount. I'm using rsync for convinience as the --progress=20
> coammand line switch gives a good immidiate=A0indicator if teh problem
exists.
>
>
> good Kernel (e.g. 5.6.0 RC7)
>
> root@S1020-CephTest:~# uname -a
> Linux S1020-CephTest 5.6.0-050600rc7-generic #202003230230 SMP Mon Mar =

> 23
> 02:33:08 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux=20
> root@S1020-CephTest:~# ls tatort.mp4
> tatort.mp4
> root@S1020-CephTest:~# ls -la tatort.mp4
> -rw-rw-r-- 1 nanoadmin nanoadmin 2106772019 Dec=A0 7 11:25 tatort.mp4=20
> root@S1020-CephTest:~# rsync -avh --progress tatort.mp4=20
> /mnt/ceph/tatort.mp4 sending incremental file list
> tatort.mp4
>  =A0 =A0 =A0 =A0 =A0 2.11G 100%=A0 138.10MB/s=A0 =A0 0:00:14 (xfr#1, =
to-chk=3D0/1)
>
> sent 2.11G bytes=A0 received 35 bytes=A0 135.95M bytes/sec total size =
is=20
> 2.11G=A0 speedup is 1.00
>
> bad Kernel (e.g. 5.6.0 FINAL)
>
> root@S1020-CephTest:~# uname -a
> Linux S1020-CephTest 5.6.0-050600-generic #202003292333 SMP Sun Mar 29
> 23:35:58 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux=20
> root@S1020-CephTest:~# rsync -avh --progress tatort.mp4=20
> /mnt/ceph/tatort.mp4 sending incremental file list
> tatort.mp4
>  =A0 =A0 =A0 =A0 =A021.59M=A0 =A01%=A0 =A0 2.49MB/s=A0 =A0 0:13:38
>
> (see attached screen shot from netdata abour the difference in iowait=20
> for both test cases)
>
>
> As Xiubo=A0supposed I tested with the very last RC kernel, too. Same
problem:
>
> Latest 6.1. RC kernel
> root@S1020-CephTest:~# uname -a
> Linux S1020-CephTest 6.1.0-060100rc5-generic #202211132230 SMP=20
> PREEMPT_DYNAMIC Sun Nov 13 22:36:10 UTC 2022 x86_64 x86_64 x86_64=20
> GNU/Linux root@S1020-CephTest:~# rsync -avh --progress tatort.mp4=20
> /mnt/ceph/tatort.mp4 sending incremental file list
> tatort.mp4
>  =A0 =A0 =A0 =A0 =A060.13M=A0 =A02%=A0 =A0 3.22MB/s=A0 =A0 0:10:20
>
> (attached a netdata screenshot for that, too).
>
> =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=

>
>> Can you describe how you performed bisection?=A0 Can you share the=20
>> reproducer you used for bisection?
> Took a commit from 5.4 which I had confirmed to be=A0bad in =
earlier=A0tests.
> Than took tag 5.4.25 which I=A0confirmed to be=A0good as first "good"
>
> # git bisect log
> git bisect start
> # bad: [61bbc823a17abb3798568cfb11ff38fc22317442] clk: ti: am43xx: Fix =

> clock parent for RTC clock git bisect bad=20
> 61bbc823a17abb3798568cfb11ff38fc22317442
> # good: [18fe53f6dfbc5ad4ff2164bff841b56d61b22720] Linux 5.4.25 git=20
> bisect good 18fe53f6dfbc5ad4ff2164bff841b56d61b22720
> # good: [59e4624e664c9e83c04abae9b710cd60cb908a82] ALSA: seq: oss: Fix =

> running status after receiving sysex git bisect good=20
> 59e4624e664c9e83c04abae9b710cd60cb908a82
> # good: [8dab286ab527dc3fa68e9705b0805f4d6ce10add] fsl/fman: detect=20
> FMan erratum A050385 git bisect good=20
> 8dab286ab527dc3fa68e9705b0805f4d6ce10add
> # bad: [160c2ffa701692e60c7034271b4c06b843b7249f] xfrm: add the=20
> missing verify_sec_ctx_len check in xfrm_add_acquire git bisect bad=20
> 160c2ffa701692e60c7034271b4c06b843b7249f
> # bad: [174da11b6474200e2e43509ce2d34e62ecea9f4b] ARM: dts: omap5: Add =

> bus_dma_limit for L3 bus git bisect bad=20
> 174da11b6474200e2e43509ce2d34e62ecea9f4b
> # good: [65047f7538ba5c0edcf4b4768d942970bb6d4cbc] iwlwifi: mvm: fix=20
> non-ACPI function git bisect good=20
> 65047f7538ba5c0edcf4b4768d942970bb6d4cbc
> # good: [10d5de234df4a4567a8da18de04111f7e931fd70] RDMA/core: Fix=20
> missing error check on dev_set_name() git bisect good=20
> 10d5de234df4a4567a8da18de04111f7e931fd70
> # good: [44960e1c39d807cd0023dc7036ee37f105617ebe] RDMA/mad: Do not=20
> crash if the rdma device does not have a umad interface git bisect=20
> good 44960e1c39d807cd0023dc7036ee37f105617ebe
> # bad: [7cdaa5cd79abe15935393b4504eaf008361aa517] ceph: fix memory=20
> leak in
> ceph_cleanup_snapid_map()
> git bisect bad 7cdaa5cd79abe15935393b4504eaf008361aa517
> # bad: [ed24820d1b0cbe8154c04189a44e363230ed647e] ceph: check=20
> POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL git bisect =

> bad ed24820d1b0cbe8154c04189a44e363230ed647e
> # first bad commit: [ed24820d1b0cbe8154c04189a44e363230ed647e] ceph:=20
> check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL

Since you are here, could you try to revert this commit and have a try ?

Let's see whether is this commit causing it. I will take a look later =
this
week.

Thanks

- Xiubo

>
>> Can you confirm the result by manually checking out the previous=20
>> commit and verifying that it's "good"?
> root@S1020-CephTest:~/src/linux# git checkout -b ceph_check_last_good=20
> 44960e1c39d807cd0023dc7036ee37f105617ebe
> Checking out files: 100% (68968/68968), done.
> Switched to a new branch 'ceph_check_last_good'
>
> root@S1020-CephTest:~/src/linux# make clean ...
> root@S1020-CephTest:~/src/linux# cp -a=20
> /boot/config-5.4.25-050425-generic
> .config
> root@S1020-CephTest:~/src/linux# make olddefconfig ...
> root@S1020-CephTest:~/src/linux# make bindeb-pkg -j"$(nproc)"
> ...
> dpkg-deb: building package 'linux-headers-5.4.28+' in=20
> '../linux-headers-5.4.28+_5.4.28+-10_amd64.deb'.
> dpkg-deb: building package 'linux-libc-dev' in=20
> '../linux-libc-dev_5.4.28+-10_amd64.deb'.
> dpkg-deb: building package 'linux-image-5.4.28+' in=20
> '../linux-image-5.4.28+_5.4.28+-10_amd64.deb'.
> dpkg-deb: building package 'linux-image-5.4.28+-dbg' in=20
> '../linux-image-5.4.28+-dbg_5.4.28+-10_amd64.deb'.
>  =A0dpkg-genbuildinfo --build=3Dbinary
>  =A0dpkg-genchanges --build=3Dbinary=20
> >../linux-5.4.28+_5.4.28+-10_amd64.changes
> dpkg-genchanges: info: binary-only upload (no source code included)
>  =A0dpkg-source --after-build linux
> dpkg-buildpackage: info: binary-only upload (no source included)=20
> root@S1020-CephTest:~/src/linux# cd ..
> root@S1020-CephTest:~/src# ls
> linux
>  =A0linux-5.4.28+_5.4.28+-10_amd64.changes
> linux-image-5.4.28+_5.4.28+-10_amd64.deb
> linux-libc-dev_5.4.28+-10_amd64.deb
> linux-5.4.28+_5.4.28+-10_amd64.buildinfo
> linux-headers-5.4.28+_5.4.28+-10_amd64.deb
> linux-image-5.4.28+-dbg_5.4.28+-10_amd64.deb
> root@S1020-CephTest:~/src# dpkg -i linux-image-5.4.28+* ...
> root@S1020-CephTest:~/src# reboot
> ....
> root@S1020-CephTest:~# uname -a
> Linux S1020-CephTest 5.4.28+ #10 SMP Fri Dec 16 09:20:11 CET 2022=20
> x86_64
> x86_64 x86_64 GNU/Linux
> root@S1020-CephTest:~# rsync -avh --progress tatort.mp4=20
> /mnt/ceph/tatort.mp4 sending incremental file list
> tatort.mp4
>  =A0 =A0 =A0 =A0 =A0 2.11G 100%=A0 135.15MB/s=A0 =A0 0:00:14 (xfr#1, =
to-chk=3D0/1)
>
> sent 2.11G bytes=A0 received 35 bytes=A0 135.95M bytes/sec total size =
is=20
> 2.11G=A0 speedup is 1.00
>
> As you can see the problem does not exist here.
>
> Thanks again!
> Marco
> ________________________________________
> From: Xiubo Li <xiubli@redhat.com>
> Sent: Friday, December 16, 2022 3:20:46 AM
> To: Ilya Dryomov; Roose, Marco
> Cc: Ceph Development
> Subject: Re: PROBLEM: CephFS write performance drops by 90%
>  =20
> Hi Roose,
>
> I think this should be similar with
> https://tracker.ceph.com/issues/57898, but it's from 5.15 instead.
>
> Days ago just after Ilya rebased to the 6.1 without changing anything=20
> in ceph code the xfstest tests were much faster.
>
> I just checked the difference about the 5.4 and 5.4.45 and couldn't=20
> know what has happened exactly. So please share your test case about =
this.
>
> - Xiubo
>
> On 15/12/2022 23:32, Ilya Dryomov wrote:
>> On Thu, Dec 15, 2022 at 3:22 PM Roose, Marco=20
>> <marco.roose@mpinat.mpg.de>
> wrote:
>>> Dear Ilya,
>>> I'm using Ubuntu and a CephFS mount. I had a more than 90% write
> performance decrease after changing the kernels main version ( <10MB/s =
vs.
> 100-140 MB/s). The problem seems to exist in Kernel major versions=20
> starting at v5.4. Ubuntu mainline version v5.4.25 is fine, v5.4.45=20
> (which is next
> available) is "bad".
>> Hi Marco,
>>
>> What is the workload?
>>
>>> After a git bisect with the "original" 5.4 kernels I get the=20
>>> following
> result:
>> Can you describe how you performed bisection?=A0 Can you share the=20
>> reproducer you used for bisection?
>>
>>> ed24820d1b0cbe8154c04189a44e363230ed647e is the first bad commit=20
>>> commit ed24820d1b0cbe8154c04189a44e363230ed647e
>>> Author: Ilya Dryomov <idryomov@gmail.com>
>>> Date:=A0=A0 Mon Mar 9 12:03:14 2020 +0100
>>>
>>>  =A0=A0=A0=A0=A0 ceph: check POOL_FLAG_FULL/NEARFULL in addition to
> OSDMAP_FULL/NEARFULL
>>>  =A0=A0=A0=A0=A0 commit 7614209736fbc4927584d4387faade4f31444fce =
upstream.
>>>
>>>  =A0=A0=A0=A0=A0 CEPH_OSDMAP_FULL/NEARFULL aren't set since mimic, =
so we need=20
>>> to
> consult
>>>  =A0=A0=A0=A0=A0 per-pool flags as well.=A0 Unfortunately the =
backwards=20
>>> compatibility
> here
>>>  =A0=A0=A0=A0=A0 is lacking:
>>>
>>>  =A0=A0=A0=A0=A0 - the change that deprecated OSDMAP_FULL/NEARFULL =
went into=20
>>> mimic,
> but
>>>  =A0=A0=A0=A0=A0=A0=A0 was guarded by require_osd_release >=3D =
RELEASE_LUMINOUS
>>>  =A0=A0=A0=A0=A0 - it was subsequently backported to luminous in =
v12.2.2, but=20
>>> that
> makes
>>>  =A0=A0=A0=A0=A0=A0=A0 no difference to clients that only check=20
>>> OSDMAP_FULL/NEARFULL
> because
>>>  =A0=A0=A0=A0=A0=A0=A0 require_osd_release is not client-facing -- =
it is for OSDs
>>>
>>>  =A0=A0=A0=A0=A0 Since all kernels are affected, the best we can do =
here is=20
>>> just
> start
>>>  =A0=A0=A0=A0=A0 checking both map flags and pool flags and send =
that to stable.
>>>
>>>  =A0=A0=A0=A0=A0 These checks are best effort, so take osdc->lock =
and look up=20
>>> pool
> flags
>>>  =A0=A0=A0=A0=A0 just once.=A0 Remove the FIXME, since filesystem =
quotas are=20
>>> checked
> above
>>>  =A0=A0=A0=A0=A0 and RADOS quotas are reflected in POOL_FLAG_FULL: =
when the=20
>>> pool
> reaches
>>>  =A0=A0=A0=A0=A0 its quota, both POOL_FLAG_FULL and =
POOL_FLAG_FULL_QUOTA are set.
>> The only suspicious thing I see in this commit is osdc->lock=20
>> semaphore which is taken for read for a short period of time in
ceph_write_iter().
>> It's possible that that started interfering with other code paths=20
>> that take that semaphore for write and read-write lock fairness=20
>> algorithm is biting...
>>
>> Can you confirm the result by manually checking out the previous=20
>> commit and verifying that it's "good"?
>>
>>  =A0=A0=A0=A0=A0 commit 44960e1c39d807cd0023dc7036ee37f105617ebe
>>  =A0=A0=A0=A0=A0 RDMA/mad: Do not crash if the rdma device does not =
have a umad
> interface
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0 (commit =
5bdfa854013ce4193de0d097931fd841382c76a7 upstream)
>>
>> Thanks,
>>
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya
>>


------=_NextPart_000_00FF_01D9139F.DF618BA0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIYeDCCBDIw
ggMaoAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwezELMAkGA1UEBhMCR0IxGzAZBgNVBAgMEkdyZWF0
ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBwwHU2FsZm9yZDEaMBgGA1UECgwRQ29tb2RvIENBIExpbWl0
ZWQxITAfBgNVBAMMGEFBQSBDZXJ0aWZpY2F0ZSBTZXJ2aWNlczAeFw0wNDAxMDEwMDAwMDBaFw0y
ODEyMzEyMzU5NTlaMHsxCzAJBgNVBAYTAkdCMRswGQYDVQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIx
EDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9kbyBDQSBMaW1pdGVkMSEwHwYDVQQDDBhB
QUEgQ2VydGlmaWNhdGUgU2VydmljZXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+
QJ30buHqdoccTUVEjr5GyIMGncEq/hgfjuQC+vOrXVCKFjELmgbQxXAizUktVGPMtm5oRgtT6stM
JMC8ck7q8RWu9FSaEgrDerIzYOLaiVXzIljz3tzP74OGooyUT59o8piQRoQnx3a/48w1LIteB2Rl
gsBIsKiR+WGfdiBQqJHHZrXreGIDVvCKGhPqMaMeoJn9OPb2JzJYbwf1a7j7FCuvt6rM1mNfc4za
BZmoOKjLF3g2UazpnvR4Oo3PD9lC4pgMqy+fDgHe75+ZSfEt36x0TRuYtUfF5SnR+ZAYx2KcvoPH
Jns+iiXHwN2d5jVoECCdj9je0sOEnA1e6C/JAgMBAAGjgcAwgb0wHQYDVR0OBBYEFKARCiM+lvEH
7OKvKe+CpX/QMKS0MA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MHsGA1UdHwR0MHIw
OKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3Js
MDagNKAyhjBodHRwOi8vY3JsLmNvbW9kby5uZXQvQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmww
DQYJKoZIhvcNAQEFBQADggEBAAhW/ALwm+j/pPrWe8ZEgM5PxMX2AFjMpra8FEloBHbo5u5d7AIP
YNaNUBhPJk4B4+awpe6/vHRUQb/9/BK4x09a9IlgBX9gtwVK8/bxwr/EuXSGti19a8zS80bdL8bg
asPDNAMsfZbdWsIOpwqZwQWLqwwv81w6z2w3VQmH3lNAbFjv/LarZW4E9hvcPOBaFcae2fFZSDAh
ZQNs7Okhc+ybA6HgN62gFRiP+roCzqcsqRATLNTlCCarIpdg+JBedNSimlO98qlo4KJuwtdssaMP
nr/raOdW8q7y4ys4OgmBtWuF174t7T8at7Jj4vViLILUagBBUPE5g5+V6TaWmG4wggWBMIIEaaAD
AgECAhA5ckQ6+SK3UdfTbBDdMTWVMA0GCSqGSIb3DQEBDAUAMHsxCzAJBgNVBAYTAkdCMRswGQYD
VQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9k
byBDQSBMaW1pdGVkMSEwHwYDVQQDDBhBQUEgQ2VydGlmaWNhdGUgU2VydmljZXMwHhcNMTkwMzEy
MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJz
ZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
LjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQCAEmUXNg7D2wiz0KxXDXbtzSfTTK1Qg2HiqiBNCS1kCdzO
iZ/MPans9s/B3PHTsdZ7NygRK0faOca8Ohm0X6a9fZ2jY0K2dvKpOyuR+OJv0OwWIJAJPuLodMkY
tJHUYmTbf6MG8YgYapAiPLz+E/CHFHv25B+O1ORRxhFnRghRy4YUVD+8M/5+bJz/Fp0YvVGONaan
ZshyZ9shZrHUm3gDwFA66Mzw3LyeTP6vBZY1H1dat//O+T23LLb2VN3I5xI6Ta5MirdcmrS3ID3K
fyI0rn47aGYBROcBTkZTmzNg95S+UzeQc0PzMsNT79uq/nROacdrjGCT3sTHDN/hMq7MkztReJVn
i+49Vv4M0GkPGw/zJSZrM233bkf6c0Plfg6lZrEpfDKEY1WJxA3Bk1QwGROs0303p+tdOmw1XNtB
1xLaqUkL39iAigmTYo61Zs8liM2EuLE/pDkP2QKe6xJMlXzzawWpXhaDzLhn4ugTncxbgtNMs+1b
/97lc6wjOy0AvzVVdAlJ2ElYGn+SNuZRkg7zJn0cTRe8yexDJtC/QV9AqURE9JnnV4eeUB9XVKg+
/XRjL7FQZQnmWEIuQxpMtPAlR1n6BB6T1CZGSlCBst6+eLf8ZxXhyVeEHg9j1uliutZfVS7qXMYo
CAQlObgOK6nyTJccBz8NUvXt7y+CDwIDAQABo4HyMIHvMB8GA1UdIwQYMBaAFKARCiM+lvEH7OKv
Ke+CpX/QMKS0MB0GA1UdDgQWBBRTeb9aqitKz1SA4dibwJ3ysgNmyzAOBgNVHQ8BAf8EBAMCAYYw
DwYDVR0TAQH/BAUwAwEB/zARBgNVHSAECjAIMAYGBFUdIAAwQwYDVR0fBDwwOjA4oDagNIYyaHR0
cDovL2NybC5jb21vZG9jYS5jb20vQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwNAYIKwYBBQUH
AQEEKDAmMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEM
BQADggEBABiHUdx0IT2ciuAntzPQLszs8ObLXhHeIm+bdY6ecv7k1v6qH5yWLe8DSn6u9I1vcjxD
O8A/67jfXKqpxq7y/Njuo3tD9oY2fBTgzfT3P/7euLSK8JGW/v1DZH79zNIBoX19+BkZyUIrE79Y
i7qkomYEdoiRTgyJFM6iTckys7roFBq8cfFb8EELmAAKIgMQ5Qyx+c2SNxntO/HkOrb5RRMmda+7
qu8/e3c70sQCkT0ZANMXXDnbP3sYDUXNk4WWL13fWRZPP1G91UUYP+1KjugGYXQjFrUNUHMnREd/
EF2JKmuFMRTE6KlqTIC8anjPuH+OdnKZDJ3+15EIFqGjX5UwggbmMIIEzqADAgECAhAxAnDUNb6b
JJr4VtDh4oVJMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEpl
cnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29y
azEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0yMDAy
MTgwMDAwMDBaFw0zMzA1MDEyMzU5NTlaMEYxCzAJBgNVBAYTAk5MMRkwFwYDVQQKExBHRUFOVCBW
ZXJlbmlnaW5nMRwwGgYDVQQDExNHRUFOVCBQZXJzb25hbCBDQSA0MIICIjANBgkqhkiG9w0BAQEF
AAOCAg8AMIICCgKCAgEAs0riIl4nW+kEWxQENTIgFK600jFAxs1QwB6hRMqvnkphfy2Q3mKbM2ot
pELKlgE8/3AQPYBo7p7yeORuPMnAuA+oMGRb2wbeSaLcZbpwXgfCvnKxmq97/kQkOFX706F9O7/h
0yehHhDjUdyMyT0zMs4AMBDRrAFn/b2vR3j0BSYgoQs16oSqadM3p+d0vvH/YrRMtOhkvGpLuzL8
m+LTAQWvQJ92NwCyKiHspoP4mLPJvVpEpDMnpDbRUQdftSpZzVKTNORvPrGPRLnJ0EEVCHR82LL6
oz915WkrgeCY9ImuulBn4uVsd9ZpubCgM/EXvVBlViKqusChSsZEn7juIsGIiDyaIhhLsd3amm8B
S3bgK6AxdSMROND6hiHT182Lmf8C+gRHxQG9McvG35uUvRu8v7bPZiJRaT7ZC2f50P4lTlnbLvWp
Xv5yv7hheO8bMXltiyLweLB+VNvg+GnfL6TW3Aq1yF1yrZAZzR4MbpjTWdEdSLKvz8+0wCwscQ81
nbDOwDt9vyZ+0eJXbRkWZiqScnwAg5/B1NUD4TrYlrI4n6zFp2pyYUOiuzP+as/AZnz63GvjFK69
WODR2W/TK4D7VikEMhg18vhuRf4hxnWZOy0vhfDR/g3aJbdsGac+diahjEwzyB+UKJOCyzvecG8b
Z/u/U8PsEMZg07iIPi8CAwEAAaOCAYswggGHMB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKy
A2bLMB0GA1UdDgQWBBRpAKHHIVj44MUbILAK3adRvxPZ5DAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0T
AQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwOAYDVR0gBDEwLzAt
BgRVHSAAMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFAGA1UdHwRJMEcw
RaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDB2BggrBgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNl
cnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDov
L29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEACgVOew2PHxM5AP1v7GLGw+3t
F6rjAcx43D9Hl110Q+BABABglkrPkES/VyMZsfuds8fcDGvGE3o5UfjSno4sij0xdKut8zMazv8/
4VMKPCA3EUS0tDUoL01ugDdqwlyXuYizeXyH2ICAQfXMtS+raz7mf741CZvO50OxMUMxqljeRfVP
DJQJNHOYi2pxuxgjKDYx4hdZ9G2o+oLlHhu5+anMDkE8g0tffjRKn8I1D1BmrDdWR/IdbBOj6870
abYvqys1qYlPotv5N5dm+XxQ8vlrvY7+kfQaAYeO3rP1DM8BGdpEqyFVa+I0rpJPhaZkeWW7cImD
QFerHW9bKzBrCC815a3WrEhNpxh72ZJZNs1HYJ+29NTB6uu4NJjaMxpk+g2puNSm4b9uVjBbPO9V
6sFSG+IBqE9ckX/1XjzJtY8Grqoo4SiRb6zcHhp3mxj3oqWi8SKNohAOKnUc7RIP6ss1hqIFyv0x
XZor4N9tnzD0Fo0JDIURjDPEgo5WTdti/MdGTmKFQNqxyZuT9uSI2Xvhz8p+4pCYkiZqpahZlHqM
Fxdw9XRZQgrP+cgtOkWEaiNkRBbvtvLdp7MCL2OsQhQEdEbUvDM9slzZXdI7NjJokVBq3O4pls3V
D2z3L/bHVBe0rBERjyM2C/HSIh84rfmAqBgklzIOqXhd+4RzadUwggfPMIIFt6ADAgECAhEA5gmD
NATGbXJklUJJUze1YzANBgkqhkiG9w0BAQwFADBGMQswCQYDVQQGEwJOTDEZMBcGA1UEChMQR0VB
TlQgVmVyZW5pZ2luZzEcMBoGA1UEAxMTR0VBTlQgUGVyc29uYWwgQ0EgNDAeFw0yMTEyMTQwMDAw
MDBaFw0yNDEyMTMyMzU5NTlaMIIBHjEOMAwGA1UEERMFODA1MzkxSDBGBgNVBAsMP01heC1QbGFu
Y2stSW5zdGl0dXQgZsO8ciBNdWx0aWRpc3ppcGxpbsOkcmUgTmF0dXJ3aXNzZW5zY2hhZnRlbjFH
MEUGA1UEChM+TWF4LVBsYW5jay1HZXNlbGxzY2hhZnQgenVyIEZvZXJkZXJ1bmcgZGVyIFdpc3Nl
bnNjaGFmdGVuIGUuVi4xGzAZBgNVBAkMEkhvZmdhcnRlbnN0cmHDn2UgODEPMA0GA1UECBMGQmF5
ZXJuMQswCQYDVQQGEwJERTEUMBIGA1UEAxMLTWFyY28gUm9vc2UxKDAmBgkqhkiG9w0BCQEWGW1h
cmNvLnJvb3NlQG1waW5hdC5tcGcuZGUwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDA
HnbMvVBAokl5ekT4w+xrim4v+jwmoJGIEVg2KSkkYXz2Bo8G/lFrSaBkVD8gv1t+NGGfnvrC0fmL
zcusfXIwkbpo1iPGhxACvF6lZfcckd7KfTrccfxjaodiVK0Is9tUhN9I6lpH6Wib1+gRvzAjOSlT
rdSf6Ftqa1Ve/IS7jyWCKWz+iLsasPzG+NqNA6FCVPsKXXHmvPu9SRCi2w5vn7PzpZM1co94xfUH
rySgwH77GifaeKe1QrLoH4G7KRCD41v4KV7e4s4MbtLZUuS0DlRUPuq/p58qmid0l9FJf9B6Rk6D
1eCSl/8szGnochqll3cRb071+O1ISx+SObNZrNsiVkeVLVUc3cXMc9zp25qmA5NyKAw4ivoea7qp
Q+2kN+ZIcgF3b3sr6gWSGO1PTfgqblyIRczYEE+0RDtxxI8EzFysk65wzx0ZnIjaZ+RJpQT2PIfz
Oh4i2C+CJa7q+4JFrCnOIMsOjyEL8W0vRoD3AVHMd7ZKxnXs5Lri4fxla5wBOa4QMT4ltPUNeT8F
eOLxd6+GQZhM06bWd9kkPIm8amJu/876xwQqV3m5LDz1EiqjrwdWRsXwkxbeF5n5dPe5S7E8bL0u
C5H7rldUQNjC2JiSMVPWxOyv6CocYAfrR1PPs5KzJEqvQf51eCZpf9/CFdzdWA/YgStmv+e4BQID
AQABo4IB3DCCAdgwHwYDVR0jBBgwFoAUaQChxyFY+ODFGyCwCt2nUb8T2eQwHQYDVR0OBBYEFDeE
IMPOe/ODIhHpkS6i5xFEmA4tMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQW
MBQGCCsGAQUFBwMEBggrBgEFBQcDAjA/BgNVHSAEODA2MDQGCysGAQQBsjEBAgJPMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly9H
RUFOVC5jcmwuc2VjdGlnby5jb20vR0VBTlRQZXJzb25hbENBNC5jcmwweAYIKwYBBQUHAQEEbDBq
MD0GCCsGAQUFBzAChjFodHRwOi8vR0VBTlQuY3J0LnNlY3RpZ28uY29tL0dFQU5UUGVyc29uYWxD
QTQuY3J0MCkGCCsGAQUFBzABhh1odHRwOi8vR0VBTlQub2NzcC5zZWN0aWdvLmNvbTBaBgNVHREE
UzBRgRltYXJjby5yb29zZUBtcGluYXQubXBnLmRlgRltYXJjby5yb29zZUBtcGlicGMubXBnLmRl
gRltYXJjby5yb29zZUBtcGluYXQubXBnLmRlMA0GCSqGSIb3DQEBDAUAA4ICAQCxXPrgPp9llNx5
dFqR9icnFaFX35Sx7lQxUj/fkxT9bcVhueZJQ+hIErrSQJFHwfrlUAhbKzBKaVSIahaB2XmqOnLo
Gz8APUsp3Gj7W7ImYnmZOqVR/CG8thXrXdxbDK0/SVIAia/gOZwrGz2iMlSxjNlGNpGOLDBwB2NE
2QBwm+aqdZ9a0woRjBl+fggq+/SBI7XrAVWA5Ld7oQ+RM/LkLhgxdb5S22OhSiGKUQBERhS1KIyC
zQ044NieQ9L1FPxLGqL85WEixpbp4pdaOJODAqaHLeAIiJI0+81KHVpe9EK6400v3HerukO+OaM6
qswSuKZbrCr1z+kQvK9IVltEiE2STY6KD5BNpE/VB1mLSATHEA9Vb0sCpG+OxCNZ50KhJX7f5sEj
nPoNkK3PQMguk5rn68Sw2J30QPXFM/8v5sCW6X3KRbwE0Jvu354d7YRmFKGBg1QAiyVj6zwUWM4v
HJQjF9Ud2iQ23ldYeYVvafzj8x7X0leXhHS0kT9gLD0UY3VOsP9uRjxxgA/jNzq+ywv8npLzxW5s
J2AQaEZauTy1uLY20CmkeUx8HtisaanVRrtOLNCuWudDZhc18y5R1UJ8ReZwu3VFhIowaKTgkSd9
JjWftvp/zU7/GnNnNpCrQZ+lwwqIlTusWGSUvH9aurzXrP6IvBur22F70GavbTGCBFMwggRPAgEB
MFswRjELMAkGA1UEBhMCTkwxGTAXBgNVBAoTEEdFQU5UIFZlcmVuaWdpbmcxHDAaBgNVBAMTE0dF
QU5UIFBlcnNvbmFsIENBIDQCEQDmCYM0BMZtcmSVQklTN7VjMAkGBSsOAwIaBQCgggHNMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIxOTEwNDg1NVowIwYJKoZI
hvcNAQkEMRYEFMPWNOo6yJdRv5z5WFvgmMLt7tdZMGoGCSsGAQQBgjcQBDFdMFswRjELMAkGA1UE
BhMCTkwxGTAXBgNVBAoTEEdFQU5UIFZlcmVuaWdpbmcxHDAaBgNVBAMTE0dFQU5UIFBlcnNvbmFs
IENBIDQCEQDmCYM0BMZtcmSVQklTN7VjMGwGCyqGSIb3DQEJEAILMV2gWzBGMQswCQYDVQQGEwJO
TDEZMBcGA1UEChMQR0VBTlQgVmVyZW5pZ2luZzEcMBoGA1UEAxMTR0VBTlQgUGVyc29uYWwgQ0Eg
NAIRAOYJgzQExm1yZJVCSVM3tWMwgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgBZQMEASowCwYJ
YIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggIAB37qysBiNobVjvcDjQvLh/+hfaE89bqHLzMLHgBhgacLZBdOgEs1
yvMLG6PXIWHF7NFB4H6XRwb0T4E3EHIXKsfkHsiRRjrTaKPXOoB+cxFm3xqtq6VslASXAcd3MVbl
vgoHZxDiba/SCON9Ed1lV0Az5JLAqLeswqJHea49ngjJIITtxX/Crs3L1lszzUwSsYLXCZtRTFv+
LMPc8d2SUD6krhZMsP1Ym2OCOeC99Sz2QEhhjdn46/MSbcWuTRST3KZL7/QG8xTnc4zZGhgeNKmB
6LuJWAOMtAbYMX9jaFHmWDMmQDNFTniMnQQG2USqNF83fH8fKIE5sLFZs0xSIvDwonIX9G2XF8gO
JvqL/fM1F3v+rdQ21HKRm8pPzeSYmRJkBOsExOBwnlYsVr5TUa1LLCLavFnR+kHf4bGB7eSvXqLl
Rs6nlWjkeVv4YwTY8wq2c0HPUo4od+LHQC7oGX3SzDNnNF66KVO0DM0pMYSZTpOGUwPEKTrYvVqq
rZX3VYdXOM9lr8NitsR2VGehjVQZvUXGfBHLywOkMtpYIRWhlP2ndb+/9WNs2xvVbqsKQS7jR4b+
+yMK3pFJIEzhioWICcnqwjFWYGKoO9xc+L72Iyqgwp/EqshzmHTQ9fG9G7VYEJDpHfojpOrb7So4
eSITH3Cfx0F43gVQv4jiEV4AAAAAAAA=

------=_NextPart_000_00FF_01D9139F.DF618BA0--
