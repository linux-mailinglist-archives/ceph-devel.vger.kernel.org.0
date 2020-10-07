Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD323285A64
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 10:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgJGIYE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 04:24:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726605AbgJGIYD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Oct 2020 04:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602059042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zl8D4KVpxLMDNxAi2ILD6WWMQ77PlQXzH2MBTjd0z/s=;
        b=h14ZnWYKEP68S/yq4kSQyljA8tpEkUM+N7D1YKWX+RfWEpv6vSJllhAW+oAQSVxywADYzM
        6TpnIoHs9aq3o038eDEKcFAZL4fpRyLKTGC58zyIlOqun9KnDKt5wlI4sla9dqT8lfnH0h
        p0zhk6WjaGt3gRHH5FjXTiATmJMrVeM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-mlI1lblVN52ts9Fy6-l2lg-1; Wed, 07 Oct 2020 04:24:00 -0400
X-MC-Unique: mlI1lblVN52ts9Fy6-l2lg-1
Received: by mail-il1-f200.google.com with SMTP id m1so964707iln.19
        for <ceph-devel@vger.kernel.org>; Wed, 07 Oct 2020 01:24:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Zl8D4KVpxLMDNxAi2ILD6WWMQ77PlQXzH2MBTjd0z/s=;
        b=LiU1e/nPUV2xKdZAuG6B1fQCybHlAxGAwCMuDN1x/NEIJap6s/N6KbV+p1o2r4l9k2
         Dn1COqabhLUuXHPqASvlIm7OnvV6K2VMhXa4GtMV9WuijZ8oBu2v3tHbBYy7QRj3NQYs
         ZupwMjQb5vns+3gbmhVz4LplEctL0PBVldK/1ldDVrNgD4WJdDLHyBTZPexUD+hwlPKO
         teYTYjU/ZNHNh9f9z0w07yir/n2uTsGJQ7my8cdIgvzySIHZiOCz5ZLC4/DXYRXo96DQ
         uGOQaoLbRYpg+/auzdWga01RzpRDMDk8mE9y11P02M49Ge52145uKIinW264PSQsec/w
         NO8g==
X-Gm-Message-State: AOAM532KcU+Ecg56vfwYVCmZnbMN9aaT3RsjuEsOnnIvR/hu4liQGgcr
        gLIiaoxN1X02DOIwWEbY312mbPgJod3rQELo4Hg/YQrrfgprAodT/SKfSSxweNL7061PWwsWECX
        BiO31WFP/L2+3Zalgd8ycKfw03VWjQqWGSktotA==
X-Received: by 2002:a92:c949:: with SMTP id i9mr1775628ilq.252.1602059039180;
        Wed, 07 Oct 2020 01:23:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3rYfWD4+Z3p8J18dJ9yvogUeDQW26LmTv6g/dg4ujeno9Ia+NSXxHNfbEeUqpkW/vkV7NVh7t8fJuwDynfuM=
X-Received: by 2002:a92:c949:: with SMTP id i9mr1775618ilq.252.1602059038936;
 Wed, 07 Oct 2020 01:23:58 -0700 (PDT)
MIME-Version: 1.0
From:   Alfonso Martinez Hidalgo <almartin@redhat.com>
Date:   Wed, 7 Oct 2020 10:23:48 +0200
Message-ID: <CAE6AcscPK6DZ+OnTaRQ6WUpKWwzdD5H+v05uf4qEbquHOhmS=w@mail.gmail.com>
Subject: "Signed-off-by" jenkins job for PRs now failing
To:     Ceph Devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi All,

It seems that this job has started to fail on several PRs.
Does anyone have privileges to fix this error?

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D test session starts =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
platform linux2 -- Python 2.7.12, pytest-4.6.11, py-1.9.0,
pluggy-0.13.1 -- /tmp/venv.4M9HM0FOIP/bin/python2.7
cachedir: .pytest_cache
rootdir: /home/jenkins-build/build/workspace/ceph-pr-commits
collecting ... collected 2 items / 1 deselected / 1 selected

ceph-build/ceph-pr-commits/build/test_commits.py::TestCommits::test_signed_=
off_by
Running command: git fetch origin
+refs/heads/master:refs/remotes/origin/master
Running command: git log -z --no-merges origin/master..HEAD
FAILED

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D FAILURES =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
________________________ TestCommits.test_signed_off_by ___________________=
_____

self =3D <test_commits.TestCommits object at 0x7f95779c8190>

    @pytest.mark.code_test
    def test_signed_off_by(self):
        signed_off_regex =3D r'Signed-off-by: \S.* <[^@]+@[^@]+\.[^@]+>'
        # '-z' puts a '\0' between commits, see later split('\0')
        check_signed_off_commits =3D 'git log -z --no-merges origin/%s..%s'=
 % (
            self.target_branch, self.source_branch)
        wrong_commits =3D list(filterfalse(
            re.compile(signed_off_regex).search,
>           self.command(check_signed_off_commits).split('\0')))

ceph-build/ceph-pr-commits/build/test_commits.py:63:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _=
 _ _

cls =3D <class 'test_commits.TestCommits'>
command =3D 'git log -z --no-merges origin/master..HEAD'

    @classmethod
    def command(cls, command):
        print("Running command:", command)
>       return check_output(shlex.split(command), cwd=3Dcls.ceph_checkout).=
decode()
E       UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in
position 68: ordinal not in range(128)

ceph-build/ceph-pr-commits/build/test_commits.py:29: UnicodeDecodeError
- generated xml file:
/home/jenkins-build/build/workspace/ceph-pr-commits/report.xml -
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D 1 failed, 1 de=
selected in 0.60 seconds =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Build step 'Execute shell' marked build as failure


Regards,
--=20

Alfonso Mart=C3=ADnez
Senior Software Engineer, Ceph Storage
Red Hat

