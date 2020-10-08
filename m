Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA294287602
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Oct 2020 16:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgJHO24 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Oct 2020 10:28:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730508AbgJHO2z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Oct 2020 10:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602167333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S6NlMD5Vg2uS7jyGNSYOXJCZbcStHYh1oaEEq/OkGbQ=;
        b=aQoyf5uhY3DJBOYDt3Vh9JhrBdAfCzDkhbq6LRbnpaV7WY+XQlmEZPnIGHZWcipaCF/B/t
        eGji1+UQe2P3vY48Am1a9ds+LScaamhgx5czYmWdZr80fKb1+/XFvb/l1U0hjhJRYngwTR
        NrRqGMAnYZHazljJGrj07sZp+sVHuuo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-SJrx4ASSPEKt-DS8v0rsOQ-1; Thu, 08 Oct 2020 10:28:52 -0400
X-MC-Unique: SJrx4ASSPEKt-DS8v0rsOQ-1
Received: by mail-wm1-f72.google.com with SMTP id u5so3214509wme.3
        for <ceph-devel@vger.kernel.org>; Thu, 08 Oct 2020 07:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S6NlMD5Vg2uS7jyGNSYOXJCZbcStHYh1oaEEq/OkGbQ=;
        b=QhwW8AbepvO3F6AL9Gf9v2OpWxdWz5FnRD9j2K3WcxJcCIx57Rz4i72CSYbG79QQB0
         gNEE7wW5VcIDHondQze31rlWXjRjMSYy7528C+r/eKxRZvobo8R0aWhJ22oU6TlpKDwg
         2XXCuOaAFBNi06vmNNi+ZR4rC7dplUFPfg6gaRTchiY0K3Q3umIOZYf3ugLP26Xhke5j
         GxJ6P9jJ/Bu/PeYp29xhT7CXaxx7qXLYier5lksBXFs3+xbKJEGv6pOlH5NU/MjlMnRh
         OtyWAP3dM3a/EIbIlX8gZu+vEL0mko976kNuNJfgAUBz2jztgiE6f+8T3D/ZDa214sUZ
         x/2g==
X-Gm-Message-State: AOAM533mD4VyjBFVenfp4O6AWXlX5j1QR8+ENb7vaM0q2siHssus6qnk
        Pf5l2GoIIi4FPPs0c9OUmj1i4oudVdC5ixY7LS1Kc1bHJoIZFSysZo9lsTBnQ+M7gXGWAXIi1Rx
        z6LMx3wxvWSbNzhwo7IIvv+Ooms+eim70v9o4Xw==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr9073965wma.88.1602167330284;
        Thu, 08 Oct 2020 07:28:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwCQRLfYeQrZCsApa8sBEVd4aZISNY+UZxqAvK+vKFIYtpDP0njT17OhG6SzTTd2+o9md9ZzTGV7oZBNyW3/M=
X-Received: by 2002:a1c:f415:: with SMTP id z21mr9073937wma.88.1602167329951;
 Thu, 08 Oct 2020 07:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAE6AcscPK6DZ+OnTaRQ6WUpKWwzdD5H+v05uf4qEbquHOhmS=w@mail.gmail.com>
In-Reply-To: <CAE6AcscPK6DZ+OnTaRQ6WUpKWwzdD5H+v05uf4qEbquHOhmS=w@mail.gmail.com>
From:   Ken Dreyer <kdreyer@redhat.com>
Date:   Thu, 8 Oct 2020 08:28:39 -0600
Message-ID: <CALqRxCxeduxdDh=xL4nGqDTEhjJqOgSpUS6F6NqvyYq4NycRfA@mail.gmail.com>
Subject: Re: "Signed-off-by" jenkins job for PRs now failing
To:     Alfonso Martinez Hidalgo <almartin@redhat.com>
Cc:     Ceph Devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I thought we were going to switch over to https://github.com/apps/dco
? Is that still the case?

- Ken

On Wed, Oct 7, 2020 at 2:25 AM Alfonso Martinez Hidalgo
<almartin@redhat.com> wrote:
>
> Hi All,
>
> It seems that this job has started to fail on several PRs.
> Does anyone have privileges to fix this error?
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D test session starts =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> platform linux2 -- Python 2.7.12, pytest-4.6.11, py-1.9.0,
> pluggy-0.13.1 -- /tmp/venv.4M9HM0FOIP/bin/python2.7
> cachedir: .pytest_cache
> rootdir: /home/jenkins-build/build/workspace/ceph-pr-commits
> collecting ... collected 2 items / 1 deselected / 1 selected
>
> ceph-build/ceph-pr-commits/build/test_commits.py::TestCommits::test_signe=
d_off_by
> Running command: git fetch origin
> +refs/heads/master:refs/remotes/origin/master
> Running command: git log -z --no-merges origin/master..HEAD
> FAILED
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D FAILURES =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> ________________________ TestCommits.test_signed_off_by _________________=
_______
>
> self =3D <test_commits.TestCommits object at 0x7f95779c8190>
>
>     @pytest.mark.code_test
>     def test_signed_off_by(self):
>         signed_off_regex =3D r'Signed-off-by: \S.* <[^@]+@[^@]+\.[^@]+>'
>         # '-z' puts a '\0' between commits, see later split('\0')
>         check_signed_off_commits =3D 'git log -z --no-merges origin/%s..%=
s' % (
>             self.target_branch, self.source_branch)
>         wrong_commits =3D list(filterfalse(
>             re.compile(signed_off_regex).search,
> >           self.command(check_signed_off_commits).split('\0')))
>
> ceph-build/ceph-pr-commits/build/test_commits.py:63:
> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _=
 _ _ _
>
> cls =3D <class 'test_commits.TestCommits'>
> command =3D 'git log -z --no-merges origin/master..HEAD'
>
>     @classmethod
>     def command(cls, command):
>         print("Running command:", command)
> >       return check_output(shlex.split(command), cwd=3Dcls.ceph_checkout=
).decode()
> E       UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in
> position 68: ordinal not in range(128)
>
> ceph-build/ceph-pr-commits/build/test_commits.py:29: UnicodeDecodeError
> - generated xml file:
> /home/jenkins-build/build/workspace/ceph-pr-commits/report.xml -
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D 1 failed, 1 =
deselected in 0.60 seconds =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> Build step 'Execute shell' marked build as failure
>
>
> Regards,
> --
>
> Alfonso Mart=C3=ADnez
> Senior Software Engineer, Ceph Storage
> Red Hat
>

