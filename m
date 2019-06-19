Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729544BFA4
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2019 19:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfFSRbH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 19 Jun 2019 13:31:07 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:46368 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfFSRbG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Jun 2019 13:31:06 -0400
Received: by mail-qt1-f174.google.com with SMTP id h21so20854550qtn.13
        for <ceph-devel@vger.kernel.org>; Wed, 19 Jun 2019 10:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lt3rkfP4rTmP9k2Jy/kZWOnK7+YvCpxotiqpP+0u2OI=;
        b=jc5dq8MpTyCP8Iuirzzkxu/l1orNUB8PiGUlOh3h7b2HkegD32q/05cT5/rAsB8880
         QstBnOGuEvye6emcVmVbaj0b7s1BLJ+9KqDWA8eFxGeLutiw/RVy55+Q0NkAwZzT2Yp4
         EQps7cOx09mBYImVup3VFgw1PGYoP4h3KDF6lb6VEGZIQ6NrxLku8vXYpEpQcJX5p8XP
         SwsUVD7L+wme5/SOBVGKwXRGVHPVRbmQqrhochQtMqVi3ixctXvBI3srYO1zeqCC9Dls
         n7b7fL+/NfGj6EVleeqHdd+aIe/ZcpdGqZam5GNJlEyuuOEQCMXTTDiigpVjP6Bn3SkU
         fSGg==
X-Gm-Message-State: APjAAAVH4I7jSEATeIHkii5tX5Tw4dJtyUW447nwmwKTlU+RzfC5HfoG
        grimrEmaYbtiUUIfs0d9j47+fMtHrBFfeeFpgbNpTA==
X-Google-Smtp-Source: APXvYqxzG7TqUihKjUmXlLRz3Lr1G0YGPuQaWvsgT/hl3vMlnmPulU5kALxFpQwIm4AFyMPUzv8ioIvgYMGexSYtMaA=
X-Received: by 2002:ac8:4252:: with SMTP id r18mr10575548qtm.357.1560965465729;
 Wed, 19 Jun 2019 10:31:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpSHbUz2GmtnND2ptUaiSD2JgagBxsPkguUkhE37N6UHFRmHw@mail.gmail.com>
In-Reply-To: <CAPpSHbUz2GmtnND2ptUaiSD2JgagBxsPkguUkhE37N6UHFRmHw@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 19 Jun 2019 10:30:39 -0700
Message-ID: <CA+2bHPYNuDabO-KC=-dqTdfA+AMs8GeVRHF2QYPE0KeunDD7OA@mail.gmail.com>
Subject: Re: [ceph-users] CephFS damaged and cannot recover
To:     Wei Jin <wjin.cn@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@lists.ceph.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 9:19 AM Wei Jin <wjin.cn@gmail.com> wrote:
>
> There are plenty of data in this cluster (2PB), please help us, thx.
> Before doing this dangerous
> operations（http://docs.ceph.com/docs/master/cephfs/disaster-recovery-experts/#disaster-recovery-experts）
> , any suggestions?
>
> Ceph version: 12.2.12
>
> ceph fs status:
>
> cephfs - 1057 clients
> ======
> +------+---------+-------------+----------+-------+-------+
> | Rank |  State  |     MDS     | Activity |  dns  |  inos |
> +------+---------+-------------+----------+-------+-------+
> |  0   |  failed |             |          |       |       |
> |  1   | resolve | n31-023-214 |          |    0  |    0  |
> |  2   | resolve | n31-023-215 |          |    0  |    0  |
> |  3   | resolve | n31-023-218 |          |    0  |    0  |
> |  4   | resolve | n31-023-220 |          |    0  |    0  |
> |  5   | resolve | n31-023-217 |          |    0  |    0  |
> |  6   | resolve | n31-023-222 |          |    0  |    0  |
> |  7   | resolve | n31-023-216 |          |    0  |    0  |
> |  8   | resolve | n31-023-221 |          |    0  |    0  |
> |  9   | resolve | n31-023-223 |          |    0  |    0  |
> |  10  | resolve | n31-023-225 |          |    0  |    0  |
> |  11  | resolve | n31-023-224 |          |    0  |    0  |
> |  12  | resolve | n31-023-219 |          |    0  |    0  |
> |  13  | resolve | n31-023-229 |          |    0  |    0  |
> +------+---------+-------------+----------+-------+-------+
> +-----------------+----------+-------+-------+
> |       Pool      |   type   |  used | avail |
> +-----------------+----------+-------+-------+
> | cephfs_metadata | metadata | 2843M | 34.9T |
> |   cephfs_data   |   data   | 2580T |  731T |
> +-----------------+----------+-------+-------+
>
> +-------------+
> | Standby MDS |
> +-------------+
> | n31-023-227 |
> | n31-023-226 |
> | n31-023-228 |
> +-------------+

Are there failovers occurring while all the ranks are in up:resolve?
MDS logs at high debug level would be helpful.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
