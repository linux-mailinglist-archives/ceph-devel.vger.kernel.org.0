Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C6C7D86C
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 11:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbfHAJXb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 05:23:31 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:46512 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbfHAJXa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Aug 2019 05:23:30 -0400
Received: by mail-wr1-f45.google.com with SMTP id z1so72746944wru.13
        for <ceph-devel@vger.kernel.org>; Thu, 01 Aug 2019 02:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=spoEVR+KueiVtScYpxG0luRhwbpR4pYNNoNVE7qCyH8=;
        b=YUFUDBiv0jSl54DFS+tbhfRBm8LPSv/XAUX5ug6A5C0NW1zfUU9JQhrbXNEfgJZoPm
         EkGWkGOEz2rMdz9naqG4AhBmoPZP8CXMRRzI+8cpTM5DGVKauwZWtX9PapSvFTMO9NSp
         7Uvl9epdJf7XiUP2piKzEO2CvUGjIIKYEKGfdzxT+Kj7shfBJiquhLUocS10DFFs1LEF
         TmRUGqf/JVN5an2Ez+v4zHwz2WP/V8THmqxPXdYQYicFqMyY7I7JHSGH7Nnuds2GPX4T
         /1GUbxkFZ87vXNDp/MdM1GSgRNxja0gW6tz87m89GXcZV9cPDnmbm1J69GnH6ZJlwTWH
         S1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=spoEVR+KueiVtScYpxG0luRhwbpR4pYNNoNVE7qCyH8=;
        b=W82hGZf14VD2GqAn3Owr2h6+hNg9nhXEqmNXB+bPcIkTuxBhmlvj6qPAnmoyc2Ur9Z
         7BsKKS2yctUbE0J29hoWcr1Ron7lD3X+EajWL3gqEE+FPfEgnGJJ2065syEKzJb29n7B
         MMCQ9gsgYLquIZnfHikKhh9QlCp+/OcTtawaCQXB4P051IJAbkqXQYVw4c5xvtwILT9H
         zIKIMXkcjKAdNRCJEYnZxSoqikY/QujssDEb/BYwazCgLKtZuhcAke7FJbM6O1+datGc
         cP5PzEBoCIjRg6AqEn3J5dq+jpC2lmY4Sp8QzbnmwYMWdGdLbu0iRJY86QYbHdM2rVY1
         8VPA==
X-Gm-Message-State: APjAAAWv+2ockdF4sE0NWKEQvIqokNDkmQUUBq8vo/m+4SrTXHLO2OE0
        0Ocy67k9YiSql/QN82coeYFnsic96JgrMg2DU6aNsI0b
X-Google-Smtp-Source: APXvYqyqP1nK0aSUEpzkXY129UftiAFiEqCN0e2LBnd6rox02hTPvOCRpH8L+GSwl40V3nuGTb4es46bBhGDcnKDJZo=
X-Received: by 2002:a5d:6389:: with SMTP id p9mr114507368wru.297.1564651408583;
 Thu, 01 Aug 2019 02:23:28 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?5r2Y5Lic5YWD?= <dongyuanpan0@gmail.com>
Date:   Thu, 1 Aug 2019 17:23:17 +0800
Message-ID: <CANkQ9LhcjLd+z804pVxkUY+sRSapVz88=VLoo2sNnXmQaj3+7A@mail.gmail.com>
Subject: about ceph v12.2.12 rpm have no found
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,every one,
  I can not found ceph v12.2.12 rpm at
https://download.ceph.com/rpm-luminous/el7/aarch64/
  why=EF=BC=9F
