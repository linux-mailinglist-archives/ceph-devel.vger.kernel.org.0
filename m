Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8999C48C142
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jan 2022 10:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352183AbiALJra (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 04:47:30 -0500
Received: from stumail2.scut.edu.cn ([202.38.213.12]:12674 "EHLO
        mail.scut.edu.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1349532AbiALJr1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jan 2022 04:47:27 -0500
Received: from DESKTOP-N4CECTO.huww98.cn (unknown [125.216.246.30])
        by main (Coremail) with SMTP id AQAAfwD3_9txo95hTsGpAA--.18080S3;
        Wed, 12 Jan 2022 17:46:26 +0800 (CST)
Date:   Wed, 12 Jan 2022 17:47:21 +0800
From:   =?utf-8?B?6IOh546u5paH?= <sehuww@mail.scut.edu.cn>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>,
        Gregory Farnum <gfarnum@redhat.com>
Subject: Re: dmesg: mdsc_handle_reply got x on session mds1 not mds0
Message-ID: <20220112094721.GA77@DESKTOP-N4CECTO.huww98.cn>
References: <787e011c.337c.17e400efdc7.Coremail.sehuww@mail.scut.edu.cn>
 <CACPzV1n3bRtd_87Yuh2ukHnNWZBFrXPnQ_EMtDc7oipjOEe6xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPzV1n3bRtd_87Yuh2ukHnNWZBFrXPnQ_EMtDc7oipjOEe6xA@mail.gmail.com>
X-CM-TRANSID: AQAAfwD3_9txo95hTsGpAA--.18080S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4DJr4xJr4rJFW3JF1kKrg_yoW8Xryxpa
        4UWa45Ar4kGw1UuF4qyF1kAry2yw4kJa4UtrWj9rn7AFs09rs3J3sxt34qvrWjqrsag3s0
        yw1xtan0qr1xAwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkFb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
        C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc2xSY4AK67AK6r4fMxAIw28I
        cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
        IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jcmiiUUUUU=
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQAEBlepTBxFyAAEsk
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 12, 2022 at 01:24:20PM +0530, Venky Shankar wrote:
> It would be interesting to see what "mds1" was doing around the
> "01:53:07" timestamp. Could you gather that from the mds log?

Nothing special:

debug 2022-01-08T17:48:03.493+0000 7f3c30d91700  1 mds.cephfs.gpu024.rpfbnh Updating MDS map to version 86134 from mon.4
debug 2022-01-08T17:48:22.029+0000 7f3c30d91700  1 mds.cephfs.gpu024.rpfbnh Updating MDS map to version 86135 from mon.4
debug 2022-01-08T17:48:40.154+0000 7f3c30d91700  1 mds.cephfs.gpu024.rpfbnh Updating MDS map to version 86136 from mon.4
debug 2022-01-08T18:01:56.084+0000 7f3c30d91700  1 mds.cephfs.gpu024.rpfbnh Updating MDS map to version 86137 from mon.4
debug 2022-01-08T18:01:59.784+0000 7f3c30d91700  1 mds.cephfs.gpu024.rpfbnh Updating MDS map to version 86138 from mon.4
debug 2022-01-08T18:08:15.788+0000 7f3c30d91700  1 mds.cephfs.gpu024.rpfbnh Updating MDS map to version 86139 from mon.4

(01:53:07 in kernel log is in timezone +08:00)

I've checked MDSMap e86137, mds.cephfs.gpu024.rpfbnh is active in rank 1

And I just checked again, the first OSD_FULL appears in the log at
'Jan 09 01:52:43' or '2022-01-08T17:52:43.726+0000'.  So the mdsc_handle_reply
dmesg can be related to OSD_FULL.  I was misleaded by the prometheus query:

ceph_osd_stat_bytes_used / ceph_osd_stat_bytes

which only reports about 79% to that full OSD at the time when OSD_FULL appears
in cluster log.

