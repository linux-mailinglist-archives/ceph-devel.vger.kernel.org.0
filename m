Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6282E472
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 20:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfE2S1X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 14:27:23 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:41890 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2S1X (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 14:27:23 -0400
Received: by mail-lj1-f177.google.com with SMTP id q16so3477508ljj.8
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 11:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ZG8a3clQ3tiGsQxFYtyNVy/TAD45EJkdVbMutD9mICg=;
        b=upb/+qwwUKxA7LHpmNMakI2riU9UAEAxKgLkIB8vtswCFtlVZN0abyG6HaAOHbhKVi
         0QgeP2Qf9QZ87zJGrTXaQAvormPg+TADOZcspVButxce7zqq7ahwpsv8LnGSvVCwXYRZ
         /Voc1J3W4Lp5hqcqvHhbx3EadoHcF/lTXSEPJ69Dyx78/DIYCsTkuCZKgS2TG9NzQpc5
         PPLRA1zTKstOT6ZJipEi0ev/fXJoZd9nU9L+IygJ/OJ8E+s9n1B5tseslV7UNWbVy3sW
         93koTLgloUJge1Z/iSAbQ+mIdNvoL0xQNZqA8nZtaSlUpgK85C91QmzKINyxUfgFW79L
         za6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ZG8a3clQ3tiGsQxFYtyNVy/TAD45EJkdVbMutD9mICg=;
        b=LQksoLqAjwwodZZc+S8lCfCR7z0Y0O5+6PkVQ9wlBcNu6rK5o/QRwiONL0LyHG+psJ
         yUPP9WsGkaWPtqYar1PdjJ9R0knq/6rsIpK/930idWeanBjPaWU1sutBEyXcIMBrBUlP
         a3CrZ1GfVexkd6UWLvlPHXWG0I23/bFOrSAUnHS84ORjsxz/ve1hF9XthD2ON0Uh4Af+
         qQLAV3DGT6X3fcvkHEMuB95xUla/jdwbZ7TFbtItXUj2mY+gI4GUqyAnSzX3bIVdkDeB
         Ay3dGz8LjBwCSCVSqIDkHHCn4apCxiTh6MMh35bdwn6DeYAa/19fgOg6Mu8T4c74a7D3
         QmXA==
X-Gm-Message-State: APjAAAUkT9wM5x8MZSGbfURs9KA2HptC9xgGSb51iDDVJUcldNXK77VT
        6NGFk6VtYU91HZL7LMj1Ji6qT75rtZvlf25CbJ7ADUEhM480DQ==
X-Google-Smtp-Source: APXvYqwahG1pUU2k4tH014iOpH6ta/qIe3uBDvLvfL6tuLBUrUXeGzNWQlgO5udm6hKsMURl8rZZRfqV9E0NbB0G0pM=
X-Received: by 2002:a2e:47cf:: with SMTP id u198mr615039lja.202.1559154441157;
 Wed, 29 May 2019 11:27:21 -0700 (PDT)
MIME-Version: 1.0
From:   Ugis <ugis22@gmail.com>
Date:   Wed, 29 May 2019 21:27:10 +0300
Message-ID: <CAE63xUOQPizvSWe4YL_2fiSJ5uYxMdOTz1nqL9QizNGxwyyWQQ@mail.gmail.com>
Subject: fully encrypted ceph
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

What are current options to set up fully encrypted ceph cluster(data
encrypted in transit & at rest)?

From what I have gathered:
option: ceph OSDs with dmcrypt and keys stored in monitors - this
seems not secure because keys travel from monitors to OSDs unencrypted
by default.

workarounds would be:
- best:to use OSDs on luks crypt devices and unlock luks locally but
somehow ceph-volume refuses to create OSD on /dev/mapper/..crypt
device - why that?
- not avaialable: to store OSD dmcrypt keys in TANG server and use
clevis to retrieve keys.
- viable but unconvenient: create VPN between osds and mons

What could be other suggestions to set up fully encrypted ceph?

Best regards,
Ugis
