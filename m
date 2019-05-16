Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD9C20D56
	for <lists+ceph-devel@lfdr.de>; Thu, 16 May 2019 18:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfEPQtF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 May 2019 12:49:05 -0400
Received: from mail-yw1-f47.google.com ([209.85.161.47]:33593 "EHLO
        mail-yw1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfEPQtF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 May 2019 12:49:05 -0400
Received: by mail-yw1-f47.google.com with SMTP id q11so1628388ywb.0
        for <ceph-devel@vger.kernel.org>; Thu, 16 May 2019 09:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xqH2PFEzWbYIxZduSq2hB7OPc4iQtOzR9QnvevBHKN8=;
        b=qZsbC0BL43T4xE9J5Yr76huikOheNnK2wuLVmYa9TstoAoerjiPpU0Vijluh8sGJfZ
         /zEpwY/98H/3v9PCEMBVY4QT5KRemv5bpuajskctPoW0fPF56rDegiag89BMRtPTWj0O
         KmlD/RQzOZ/Pm7N95xXkCSwTSuHXA1F4TmWeANFH+vYddVHNRemNFk3d43e5rxF+G9hl
         Q7xtCKhbEPpXoKca+FVjHytkUn+7FHU2vbXwXBcOHA1VSO/NjAp7uFLkm22bXjeJxsZ+
         6rB4oCvv0XOcLlXsIUdnVBg3eRadapqJWOyKf7IqJK/YiZhgwVSl5ftIOFzDWQyiMbcj
         3sAQ==
X-Gm-Message-State: APjAAAUiC4Bofp2CsTjzWXfrR1MLpW0w2UbijzyFvHFFTe+QaTHNZsoV
        tr9oPgcilkF69Yg7y+c0mV1r0j3+LZc=
X-Google-Smtp-Source: APXvYqx8xp6F6LL6uy3nCnYkVJ2vyrlT5KMgCsy+nM5H1+V2XKp87GwnCH1HyRqd2uIBzEHpEIheEg==
X-Received: by 2002:a81:32d6:: with SMTP id y205mr23225032ywy.108.1558025344439;
        Thu, 16 May 2019 09:49:04 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-C3D.dyn6.twc.com. [2606:a000:1100:37d::c3d])
        by smtp.gmail.com with ESMTPSA id n12sm2206445ywn.81.2019.05.16.09.49.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 09:49:03 -0700 (PDT)
Message-ID: <890c2e19487ac12e1b79e611a15042a2d829598b.camel@redhat.com>
Subject: Re: CephFS: strange behavior for arm-gcc when runing under cephfs
From:   Jeff Layton <jlayton@redhat.com>
To:     Xinying Song <songxinying.ftd@gmail.com>,
        ceph-devel@vger.kernel.org
Date:   Thu, 16 May 2019 12:49:03 -0400
In-Reply-To: <CAMWWNq9gsx8NGap3zUn+Db-WDt1hCLU8SBHwxBBuUHcnjbjZqw@mail.gmail.com>
References: <CAMWWNq9gsx8NGap3zUn+Db-WDt1hCLU8SBHwxBBuUHcnjbjZqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-05-16 at 20:31 +0800, Xinying Song wrote:
> Hi, cephers:
> I'm using ceph Luminous. Recently, one of my colleagues put his
> gcc-tools , a whole binary folder with corresponding lib-files, into
> cephfs. However, when running arm-gcc command to compile files,
> arm-gcc always complains about "cc1plus" not found. If the whole
> binary folder is located under a local filesystem, everything is ok.
> 
> Here is some pieces of log with strace when run arm-gcc under cephfs:
> 
> open("/tmp/ccIlAAE5.s", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
> close(3)                                = 0
> stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/arm-linux-gnueabihf/4.9.2/cc1plus",
> {st_mode=S_IFREG|0755, st_size=16224744, ...}) = 0
> stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/arm-linux-gnueabihf/cc1plus",
> 0xfffe9014) = -1 ENOENT (No such file or directory)
> stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/cc1plus",
> 0xfffe9014) = -1 ENOENT (No such file or directory)
> stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../lib/gcc/arm-linux-gnueabihf/4.9.2/../../../../arm-linux-gnueabihf/bin/arm-linux-gnueabihf/4.9.2/cc1plus",
> 0xfffe9014) = -1 ENOENT (No such file or directory)
> stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../lib/gcc/arm-linux-gnueabihf/4.9.2/../../../../arm-linux-gnueabihf/bin/arm-linux-gnueabihf/cc1plus",
> 0xfffe9014) = -1 ENOENT (No such file or directory)
> stat64("/mnt/cephfs/CentOS-6.6/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../lib/gcc/arm-linux-gnueabihf/4.9.2/../../../../arm-linux-gnueabihf/bin/cc1plus",
> 0xfffe9014) = -1 ENOENT (No such file or directory)
> vfork(arm-linux-gnueabihf-g++: error trying to exec 'cc1plus': execvp:
> No such file or directory
> )                                 = 8885
> --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=8885,
> si_status=255, si_utime=0, si_stime=0} ---
> waitpid(8885, [{WIFEXITED(s) && WEXITSTATUS(s) == 255}], 0) = 8885
> stat64("/tmp/ccIlAAE5.s", {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
> unlink("/tmp/ccIlAAE5.s")               = 0
> exit_group(1)                           = ?
> 
> It shows arm-gcc has indeed found cc1plus, but somehow it continues to
> search other directories.
> 
> Below gives log for running arm-gcc under local filesystem:
> 
> open("/tmp/ccU6Mkbg.s", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
> close(3)                                = 0
> stat64("/mnt/local/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/arm-linux-gnueabihf/4.9.2/cc1plus",
> {st_mode=S_IFREG|0755, st_size=16224744, ...}) = 0
> access("/mnt/local/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/../libexec/gcc/arm-linux-gnueabihf/4.9.2/cc1plus",
> X_OK) = 0
> vfork()                                 = 8866
> waitpid(8866, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0) = 8866
> --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=8866,
> si_status=0, si_utime=16, si_stime=5} ---
> 
> The main difference is that when using a local filesystem, arm-gcc
> will not continue to look up in other directories after it has found
> cc1plus. I'm really confused by this behavior. MDS's log just showed
> it received some lookup requests and responded each request correctly.
> 
> The /mnt/local/CentOS-6.6 is copied from /mnt/cephfs/CentOS-6.6 with
> `cp -rp` command, so symbol-link or file-mode should keep the same. I
> tried gcc in this gcc-tool directory, and it worked well under cephfs.
> Probably there is a bug in arm-gcc, but I can't imagine what code will
> lead to such strange behavior.
> 
> Could anyone give some tips on this? Thanks!

One possibility is that even though the stat64 call succeeded, some of
the attributes in the returned struct stat made the program consider it
unsuitable for some reason.

I'd redo those straces with -v, longer -s value, etc., and see whether
you can discern any major differences between the corresponding stat64
calls.
-- 
Jeff Layton <jlayton@redhat.com>

