Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FF3206F4
	for <lists+ceph-devel@lfdr.de>; Thu, 16 May 2019 14:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfEPMbg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 May 2019 08:31:36 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:36365 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfEPMbg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 May 2019 08:31:36 -0400
Received: by mail-oi1-f174.google.com with SMTP id l203so2374218oia.3
        for <ceph-devel@vger.kernel.org>; Thu, 16 May 2019 05:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=JniWx40P07TISNgfJY6pmMPuWwCB4Bf2tW3weRu3S6c=;
        b=aD992qBD7CLl0G3FfhgwipgYLZL2s8yhRhjfGVSb8ucggYW1btg+VZuVF5gOKi/zK5
         kNL2vliibEN1kEhpfdlWqAlwtGFoKvZDhueykVG6TLPzxGSyirp5stOGJgpethZznAXp
         4EE7t1lWv2n/A69R90LYKbUAxmudVYg/QHwybDzF8VZoeZxi4TkpW4KbE/N8ueeBakRL
         r6P69AX/SoTA3UNh6j7b0xPtcVRW71LdF5eSyl+p0jmSHJAn12Dg01OJF85UNQhCJ/gk
         sn/4G7JjE0MCy9wmBipDDH6RLlj63afyX/1hbzzoulMaz089KMTZlfxU1hFc9IKyvE8s
         z2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JniWx40P07TISNgfJY6pmMPuWwCB4Bf2tW3weRu3S6c=;
        b=pWrUnFLgpnKdHJmro6fDU4rNXzYOEymt0mHB4wyeRZbhFgtuK+87p4GW+p//8wQ2PE
         oE1b5seNP6dkuSSx7EnDGxL21ugzgSc8V8i4ChL9Zecj7l+Jn4N7dR4UXy1mG/A1rSfa
         wS4+HDh4i2D6MYM4adYWA2lkVpkkDEYU6xdU4wrSEVJvO4W/ejPQ8KdRi/jbLEdi/NOu
         lmoJS8mjQ33KS+ZgN6hUkzVOXHBlvsnfiVsccld06Efelyps0evHL7KOGkfMFN1TVwXr
         nvAkxaqYfOe3UZ+TkGc7Fv+J+7Bmn4MZej0WMowgQg0hBQxdP8WVLzLUMOtibTkzSeji
         ehJQ==
X-Gm-Message-State: APjAAAVByiFE8/vf8FygC4p5nveaHvZxJ4+wa6lKggTqLaqy53AUqBGF
        BhMnDiJZSuZwGI6BjTs+DHqqcuFsk6dzpt49HHUynir8
X-Google-Smtp-Source: APXvYqxtu2lQynxdDN+vrXqqZCDx//0ze8exyti4qbVREQqIOM+LioMw4mGqrpoEAVmTkzUMd7P88YhoEJpfd0x7UmI=
X-Received: by 2002:aca:4883:: with SMTP id v125mr10125688oia.76.1558009895260;
 Thu, 16 May 2019 05:31:35 -0700 (PDT)
MIME-Version: 1.0
From:   Xinying Song <songxinying.ftd@gmail.com>
Date:   Thu, 16 May 2019 20:31:24 +0800
Message-ID: <CAMWWNq9gsx8NGap3zUn+Db-WDt1hCLU8SBHwxBBuUHcnjbjZqw@mail.gmail.com>
Subject: CephFS: strange behavior for arm-gcc when runing under cephfs
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, cephers:
I'm using ceph Luminous. Recently, one of my colleagues put his
gcc-tools , a whole binary folder with corresponding lib-files, into
cephfs. However, when running arm-gcc command to compile files,
arm-gcc always complains about "cc1plus" not found. If the whole
binary folder is located under a local filesystem, everything is ok.

Here is some pieces of log with strace when run arm-gcc under cephfs:

open("/tmp/ccIlAAE5.s", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
close(3)                                = 0
stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/arm-linux-gnueabihf/4.9.2/cc1plus",
{st_mode=S_IFREG|0755, st_size=16224744, ...}) = 0
stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/arm-linux-gnueabihf/cc1plus",
0xfffe9014) = -1 ENOENT (No such file or directory)
stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/cc1plus",
0xfffe9014) = -1 ENOENT (No such file or directory)
stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../lib/gcc/arm-linux-gnueabihf/4.9.2/../../../../arm-linux-gnueabihf/bin/arm-linux-gnueabihf/4.9.2/cc1plus",
0xfffe9014) = -1 ENOENT (No such file or directory)
stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../lib/gcc/arm-linux-gnueabihf/4.9.2/../../../../arm-linux-gnueabihf/bin/arm-linux-gnueabihf/cc1plus",
0xfffe9014) = -1 ENOENT (No such file or directory)
stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../lib/gcc/arm-linux-gnueabihf/4.9.2/../../../../arm-linux-gnueabihf/bin/cc1plus",
0xfffe9014) = -1 ENOENT (No such file or directory)
vfork(arm-linux-gnueabihf-g++: error trying to exec 'cc1plus': execvp:
No such file or directory
)                                 = 8885
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=8885,
si_status=255, si_utime=0, si_stime=0} ---
waitpid(8885, [{WIFEXITED(s) && WEXITSTATUS(s) == 255}], 0) = 8885
stat64("/tmp/ccIlAAE5.s", {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
unlink("/tmp/ccIlAAE5.s")               = 0
exit_group(1)                           = ?

It shows arm-gcc has indeed found cc1plus, but somehow it continues to
search other directories.

Below gives log for running arm-gcc under local filesystem:

open("/tmp/ccU6Mkbg.s", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
close(3)                                = 0
stat64("/mnt/local/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/arm-linux-gnueabihf/4.9.2/cc1plus",
{st_mode=S_IFREG|0755, st_size=16224744, ...}) = 0
access("/mnt/local/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/arm-linux-gnueabihf/4.9.2/cc1plus",
X_OK) = 0
vfork()                                 = 8866
waitpid(8866, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0) = 8866
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=8866,
si_status=0, si_utime=16, si_stime=5} ---

The main difference is that when using a local filesystem, arm-gcc
will not continue to look up in other directories after it has found
cc1plus. I'm really confused by this behavior. MDS's log just showed
it received some lookup requests and responded each request correctly.

The /mnt/local/CentOS-6.6 is copied from /mnt/cephfs/CentOS-6.6 with
`cp -rp` command, so symbol-link or file-mode should keep the same. I
tried gcc in this gcc-tool directory, and it worked well under cephfs.
Probably there is a bug in arm-gcc, but I can't imagine what code will
lead to such strange behavior.

Could anyone give some tips on this? Thanks!
