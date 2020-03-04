Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147EB178F36
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 12:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgCDLFe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 06:05:34 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43844 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgCDLFe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 06:05:34 -0500
Received: by mail-oi1-f194.google.com with SMTP id p125so1642503oif.10
        for <ceph-devel@vger.kernel.org>; Wed, 04 Mar 2020 03:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uyasdiS7HU8H6PDILARNfJ8VCzu7AHMosudusfmCmm4=;
        b=VFoWYUCd1bcQ8dQlcUYMQcv2uMLemMeRl4OI21No/84gFvsHoCUqm9E+wkEqg7t6R/
         QYLcLu/Hh2dISezSYtDHzxKRuWhOTMjnoSw2Vywy3AU1arBU1foAv9EyYTjZuGZ+Ip7o
         V5P3OO0e7dogqGD8/XiNb8DZaGRAeAwm+fIw342t4m9eOzhaY6kuNc5dKBO13awRSCRf
         n8zYTTemsNnCKc9QcAmulqWubkOClrErSwvoJu/188YuIcw4KF5TiuKHPtYjd5z+PGdk
         lOLwys0disku1kUnp/+yvgvKdqIH91zQmZ5KBl2cP8M2I+kX2xrqv6v9f20lCWNdAIIJ
         AXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uyasdiS7HU8H6PDILARNfJ8VCzu7AHMosudusfmCmm4=;
        b=rBRDunet5Mh0gfpFa7xGLcVPpqx3LIhl8d98tnqoBhBrkVwUqaCdy7JtCXPtzQ/w8p
         eWItiSAoqW84ZlL0bN7ZNaIHnPwBAG+m0cDCY5TLE4jBry7YdceGCiiPETRdU9niLQCP
         uLnuJPceFodP9VRNPFoOq6cfKFFdP3v6kuyOckh65GSz9W+xBUyKaKyqFw93A6ZRDVK0
         x/Z5ewtTLymKyjR5v4UpF0KeD2AekWSiX1rXqaDWf7uHfUKpMdwFgByGCFx8qUDZ58Io
         McSfXnER7KatCyyKhhh5IfkKY/Mek0whwMDb4pRuK6LZn/1zDrx2qva90bNO3/QZ9jUv
         Op0A==
X-Gm-Message-State: ANhLgQ0nigoxqVuoJDuVNHDnBrhsqeo6/2aSJLknueTYUdD8llu1fKYw
        /YBjNg0BL/FX8zrBIfuEO/42AAWw7xqInt9JZGQ=
X-Google-Smtp-Source: ADFU+vtV8aDvZJD3iQ3PJUPc6WBtCa3Xg8iu6Gj/b58KxlGePQILupA7zuKRDBh0mkI47DGd2YilJwdEARgJ/1fOt9c=
X-Received: by 2002:aca:538e:: with SMTP id h136mr1327828oib.39.1583319933223;
 Wed, 04 Mar 2020 03:05:33 -0800 (PST)
MIME-Version: 1.0
References: <87sgipaa4v.fsf@suse.com> <CAC+Jd5B5XBqK9R3+KGRiRG=6ChYYP3uCkHrOf8FCy67B=1GKOQ@mail.gmail.com>
In-Reply-To: <CAC+Jd5B5XBqK9R3+KGRiRG=6ChYYP3uCkHrOf8FCy67B=1GKOQ@mail.gmail.com>
From:   kefu chai <tchaikov@gmail.com>
Date:   Wed, 4 Mar 2020 19:05:21 +0800
Message-ID: <CAJE9aOPKtMmVNeHH2H-LE2pYvDfpdAONWAifmBJcTAWqu=k-dQ@mail.gmail.com>
Subject: Re: v14.2.8 Nautilus released
To:     Kaleb Keithley <kkeithle@redhat.com>
Cc:     Abhishek Lekshmanan <abhishek@suse.com>, ceph-users@ceph.io,
        dev <dev@ceph.io>,
        The Esoteric Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 4, 2020 at 3:46 AM Kaleb Keithley <kkeithle@redhat.com> wrote:
>
>
> Just FYI, 14.2.8 build fails on Fedora-32 on S390x. Other architectures b=
uild fine.
>

Kaleb, see https://github.com/ceph/ceph/pull/33716. hopefully we can
get in the next release or probably you could include this patch in
the rpm packaging?

> Build log at https://kojipkgs.fedoraproject.org//work/tasks/6999/42146999=
/build.log
>
> On Tue, Mar 3, 2020 at 7:38 AM Abhishek Lekshmanan <abhishek@suse.com> wr=
ote:
>>
>>
>> This is the eighth update to the Ceph Nautilus release series. This rele=
ase
>> fixes issues across a range of subsystems. We recommend that all users u=
pgrade
>> to this release. Please note the following important changes in this
>> release; as always the full changelog is posted at:
>> https://ceph.io/releases/v14-2-8-nautilus-released
>>
>> Notable Changes
>> ---------------
>>
>> * The default value of `bluestore_min_alloc_size_ssd` has been changed
>>   to 4K to improve performance across all workloads.
>>
>> * The following OSD memory config options related to bluestore cache aut=
otuning can now
>>   be configured during runtime:
>>
>>     - osd_memory_base (default: 768 MB)
>>     - osd_memory_cache_min (default: 128 MB)
>>     - osd_memory_expected_fragmentation (default: 0.15)
>>     - osd_memory_target (default: 4 GB)
>>
>>   The above options can be set with::
>>
>>     ceph config set osd <option> <value>
>>
>> * The MGR now accepts `profile rbd` and `profile rbd-read-only` user cap=
s.
>>   These caps can be used to provide users access to MGR-based RBD functi=
onality
>>   such as `rbd perf image iostat` an `rbd perf image iotop`.
>>
>> * The configuration value `osd_calc_pg_upmaps_max_stddev` used for upmap
>>   balancing has been removed. Instead use the mgr balancer config
>>   `upmap_max_deviation` which now is an integer number of PGs of deviati=
on
>>   from the target PGs per OSD.  This can be set with a command like
>>   `ceph config set mgr mgr/balancer/upmap_max_deviation 2`.  The default
>>   `upmap_max_deviation` is 1.  There are situations where crush rules
>>   would not allow a pool to ever have completely balanced PGs.  For exam=
ple, if
>>   crush requires 1 replica on each of 3 racks, but there are fewer OSDs =
in 1 of
>>   the racks.  In those cases, the configuration value can be increased.
>>
>> * RGW: a mismatch between the bucket notification documentation and the =
actual
>>   message format was fixed. This means that any endpoints receiving buck=
et
>>   notification, will now receive the same notifications inside a JSON ar=
ray
>>   named 'Records'. Note that this does not affect pulling bucket notific=
ation
>>   from a subscription in a 'pubsub' zone, as these are already wrapped i=
nside
>>   that array.
>>
>> * CephFS: multiple active MDS forward scrub is now rejected. Scrub curre=
ntly
>>   only is permitted on a file system with a single rank. Reduce the rank=
s to one
>>   via `ceph fs set <fs_name> max_mds 1`.
>>
>> * Ceph now refuses to create a file system with a default EC data pool. =
For
>>   further explanation, see:
>>   https://docs.ceph.com/docs/nautilus/cephfs/createfs/#creating-pools
>>
>> * Ceph will now issue a health warning if a RADOS pool has a `pg_num`
>>   value that is not a power of two. This can be fixed by adjusting
>>   the pool to a nearby power of two::
>>
>>     ceph osd pool set <pool-name> pg_num <new-pg-num>
>>
>>   Alternatively, the warning can be silenced with::
>>
>>     ceph config set global mon_warn_on_pool_pg_num_not_power_of_two fals=
e
>>
>> Getting Ceph
>> ------------
>>
>> * Git at git://github.com/ceph/ceph.git
>> * Tarball at http://download.ceph.com/tarballs/ceph-14.2.8.tar.gz
>> * For packages, see http://docs.ceph.com/docs/master/install/get-package=
s/
>> * Release git sha1: 2d095e947a02261ce61424021bb43bd3022d35cb
>>
>> --
>> Abhishek Lekshmanan
>> SUSE Software Solutions Germany GmbH
>> GF: Felix Imend=C3=B6rffer HRB 21284 (AG N=C3=BCrnberg)
>> _______________________________________________
>> Dev mailing list -- dev@ceph.io
>> To unsubscribe send an email to dev-leave@ceph.io
>
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io



--=20
Regards
Kefu Chai
