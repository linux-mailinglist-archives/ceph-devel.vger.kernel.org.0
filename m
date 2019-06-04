Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF183502D
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 21:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfFDTSG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 15:18:06 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:36990 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFDTSG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 15:18:06 -0400
Received: by mail-qk1-f169.google.com with SMTP id d15so3590728qkl.4
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 12:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iss-integration-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/q55e+Hd7Hc3bGxsMPBDAzDcP7ymcX7+/GPAU4JJOp0=;
        b=PVZpMT42guiTCmutIat7irSSaHLcA1pcBPBpBFnm/4XPa+8F1gbmYy26zc5ZVGvGWZ
         Xk7HKaz9+T3T+ZSnyNmJW8gzjh2h0w9OLUWggm69YvCeVAla2VVRi1cdSH3ob6t/GuoO
         4cpQFsRpHoyCz7fXEq3CUtIAdjzBBHk57t8mcGYODiflQKmSCqn4Qp8R4H+84l895u++
         NTlyEwK41hrdA3QVAJTck0EirFx6ww0Z22rmVIlNz7osanVOwFfOpukoF8h23tJZQMSw
         YVt1sH3WFLaL9V4Q76rGCKoNiur33VWVBQL5zDzwN6ZCelBoLYV0N+JsqRQv9yI7zeKQ
         N1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/q55e+Hd7Hc3bGxsMPBDAzDcP7ymcX7+/GPAU4JJOp0=;
        b=W/cB4YTaYEv5eW8DqoRfY6yYPieDMIa7fYExYFuXpfixRafigTAMl5did0f57CX2Qo
         dRHvbcMIAFDWtGwGNx8zqNurrtM7QYpd9HOeeYKvNXiS30+ayH7HkgHL94BICZDS4oRO
         APIGIuXteeUy0NeZMg8sDbNhNHtdfvs/T6EoIuGn5E0YsYQxGYn6H9MatGDek+b0Duy2
         5kahnpL5UkXbZfMwSLiZMYsUy/EFtozV+agSjS2UDB2Ce+piRWLcdyDYdfNfqvv/SaoP
         +8QKzHhvmkipA7aZAQF26MpTh+hZQBqsB35t30LGcsGazlfD7Ymyq7qSYp4POR1VZIJd
         lL/w==
X-Gm-Message-State: APjAAAVIJkXmFnzEaXreXmfX0YeYF42lVcBJuzbDsydiKDuER4ls0wMC
        u4Q2QcSkEP0BjmpnSewbfcohfgLPTPij7s18CZoG8CLqco8=
X-Google-Smtp-Source: APXvYqwcy8y1pdYR+JjXLvyVFfKRqOzdNj/uBIz8za6qVDH/auAjr9qsctohUIily1kA500jj2I1XNaaODQ4vKFFZIg=
X-Received: by 2002:a37:8306:: with SMTP id f6mr28211918qkd.19.1559675884257;
 Tue, 04 Jun 2019 12:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <df92623921805e9bb0eca521a170091f@suse.com>
In-Reply-To: <df92623921805e9bb0eca521a170091f@suse.com>
From:   Alex Gorbachev <ag@iss-integration.com>
Date:   Tue, 4 Jun 2019 15:17:50 -0400
Message-ID: <CADb9452mh6YaVoeZHLWk2mOeBfSuOrVK76mFDYkauye4-6z7MA@mail.gmail.com>
Subject: Re: [ceph-users] v12.2.5 Luminous released
To:     Abhishek <abhishek@suse.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ceph-User <ceph-users@ceph.com>, ceph-maintainers@ceph.com,
        ceph-announce@ceph.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Late question, but I am noticing

ceph-volume: automatic VDO detection

Does this mean that the OSD layer will at some point support
deployment with VDO?

Or that one could build on top of VDO devices and Ceph would detect
this and report somewhere?

Best,
--
Alex Gorbachev
ISS Storcium

On Tue, Apr 24, 2018 at 4:29 PM Abhishek <abhishek@suse.com> wrote:
>
> Hello cephers,
>
> We're glad to announce the fifth bugfix release of Luminous v12.2.x long
> term stable
> release series. This release contains a range of bug fixes across all
> compoenents of Ceph. We recommend all the users of 12.2.x series to
> update.
>
> Notable Changes
> ---------------
>
> * MGR
>
>    The ceph-rest-api command-line tool included in the ceph-mon
>    package has been obsoleted by the MGR "restful" module. The
>    ceph-rest-api tool is hereby declared deprecated and will be dropped
>    in Mimic.
>
>    The MGR "restful" module provides similar functionality via a "pass
> through"
>    method. See http://docs.ceph.com/docs/luminous/mgr/restful for
> details.
>
> * CephFS
>
>    Upgrading an MDS cluster to 12.2.3+ will result in all active MDS
>    exiting due to feature incompatibilities once an upgraded MDS comes
>    online (even as standby). Operators may ignore the error messages
>    and continue upgrading/restarting or follow this upgrade sequence:
>
>    Reduce the number of ranks to 1 (`ceph fs set <fs_name> max_mds 1`),
>    wait for all other MDS to deactivate, leaving the one active MDS,
>    upgrade the single active MDS, then upgrade/start standbys. Finally,
>    restore the previous max_mds.
>
>    See also: https://tracker.ceph.com/issues/23172
>
>
> Other Notable Changes
> ---------------------
>
> * add --add-bucket and --move options to crushtool (issue#23472,
> issue#23471, pr#21079, Kefu Chai)
> * BlueStore.cc: _balance_bluefs_freespace: assert(0 =3D=3D "allocate fail=
ed,
> wtf") (issue#23063, pr#21394, Igor Fedotov, xie xingguo, Sage Weil, Zac
> Medico)
> * bluestore: correctly check all block devices to decide if journal
> is\_=E2=80=A6 (issue#23173, issue#23141, pr#20651, Greg Farnum)
> * bluestore: statfs available can go negative (issue#23074, pr#20554,
> Igor Fedotov, Sage Weil)
> * build Debian installation packages failure (issue#22856, issue#22828,
> pr#20250, Tone Zhang)
> * build/ops: deb: move python-jinja2 dependency to mgr (issue#22457,
> pr#20748, Nathan Cutler)
> * build/ops: deb: move python-jinja2 dependency to mgr (issue#22457,
> pr#21233, Nathan Cutler)
> * build/ops: run-make-check.sh: fix SUSE support (issue#22875,
> issue#23178, pr#20737, Nathan Cutler)
> * cephfs-journal-tool: Fix Dumper destroyed before shutdown
> (issue#22862, issue#22734, pr#20251, dongdong tao)
> * ceph.in: print all matched commands if arg missing (issue#22344,
> issue#23186, pr#20664, Luo Kexue, Kefu Chai)
> * ceph-objectstore-tool command to trim the pg log (issue#23242,
> pr#20803, Josh Durgin, David Zafman)
> * ceph osd force-create-pg cause all ceph-mon to crash and unable to
> come up again (issue#22942, pr#20399, Sage Weil)
> * ceph-volume: adds raw device support to 'lvm list' (issue#23140,
> pr#20647, Andrew Schoen)
> * ceph-volume: allow parallel creates (issue#23757, pr#21509, Theofilos
> Mouratidis)
> * ceph-volume: allow skipping systemd interactions on activate/create
> (issue#23678, pr#21538, Alfredo Deza)
> * ceph-volume: automatic VDO detection (issue#23581, pr#21505, Alfredo
> Deza)
> * ceph-volume be resilient to $PATH issues (pr#20716, Alfredo Deza)
> * ceph-volume: fix action plugins path in tox (pr#20923, Guillaume
> Abrioux)
> * ceph-volume Implement an 'activate all' to help with dense servers or
> migrating OSDs (pr#21533, Alfredo Deza)
> * ceph-volume improve robustness when reloading vms in tests (pr#21072,
> Alfredo Deza)
> * ceph-volume lvm.activate error if no bluestore OSDs are found
> (issue#23644, pr#21335, Alfredo Deza)
> * ceph-volume: Nits noticed while studying code (pr#21565, Dan Mick)
> * ceph-volume tests alleviate libvirt timeouts when reloading
> (issue#23163, pr#20754, Alfredo Deza)
> * ceph-volume update man page for prepare/activate flags (pr#21574,
> Alfredo Deza)
> * ceph-volume: Using --readonly for {vg|pv|lv}s commands (pr#21519,
> Erwan Velu)
> * client: allow client to use caps that are revoked but not yet returned
> (issue#23028, issue#23314, pr#20904, Jeff Layton)
> * : Client:Fix readdir bug (issue#22936, pr#20356, dongdong tao)
> * client: release revoking Fc after invalidate cache (issue#22652,
> pr#20342, "Yan, Zheng")
> * Client: setattr should drop "Fs" rather than "As" for mtime and size
> (issue#22935, pr#20354, dongdong tao)
> * client: use either dentry_invalidate_cb or remount_cb to invalidate k=
=E2=80=A6
> (issue#23355, pr#20960, Zhi Zhang)
> * cls/rbd: group_image_list incorrectly flagged as RW (issue#23407,
> issue#23388, pr#20967, Jason Dillaman)
> * cls/rgw: fix bi_log_iterate_entries return wrong truncated
> (issue#22737, issue#23225, pr#21054, Tianshan Qu)
> * cmake: rbd resource agent needs to be executable (issue#22980,
> pr#20617, Tim Bishop)
> * common/dns_resolv.cc: Query for AAAA-record if ms_bind_ipv6 is True
> (issue#23078, issue#23174, pr#20710, Wido den Hollander)
> * common/ipaddr: Do not select link-local IPv6 addresses (issue#21813,
> pr#21111, Willem Jan Withagen)
> * common: omit short option for id in help for clients (issue#23156,
> issue#23041, pr#20654, Patrick Donnelly)
> * common: should not check for VERSION_ID (issue#23477, issue#23478,
> pr#21090, Kefu Chai, Shengjing Zhu)
> * config: Change bluestore_cache_kv_max to type INT64 (pr#20334, Zhi
> Zhang)
> * Couldn't init storage provider (RADOS) (issue#23349, issue#22351,
> pr#20896, Brad Hubbard)
> * doc: Add missing pg states from doc (issue#23113, pr#20584, David
> Zafman)
> * doc: outline upgrade procedure for mds cluster (issue#23634,
> issue#23568, pr#21352, Patrick Donnelly)
> * doc/rgw: add page for http frontend configuration (issue#13523,
> issue#22884, pr#20242, Casey Bodley)
> * doc: rgw: mention the civetweb support for binding to multiple ports
> (issue#20942, issue#23317, pr#20906, Abhishek Lekshmanan)
> * docs fix ceph-volume missing sub-commands (pr#20691, Katie Holly, Yao
> Zongyou, David Galloway, Sage Weil, Alfredo Deza)
> * doc: update man page to explain ceph-volume support bluestore
> (issue#23142, issue#22663, pr#20679, lijing)
> * Double free in rados_getxattrs_next (issue#22940, issue#22042,
> pr#20358, Gu Zhongyan)
> * fixes for openssl & libcurl (issue#23239, issue#23245, issue#22951,
> issue#23221, issue#23203, pr#20722, Marcus Watts, Abhishek Lekshmanan,
> Jesse Williamson)
> * invalid JSON returned when querying pool parameters (issue#23312,
> issue#23200, pr#20890, Chang Liu)
> * is_qemu_running in qemu_rebuild_object_map.sh and
> qemu_dynamic_features.sh may return false positive (issue#23524,
> pr#21192, Mykola Golub)
> * [journal] allocating a new tag after acquiring the lock should use
> on-disk committed position (issue#23011, issue#22945, pr#20454, Jason
> Dillaman)
> * journal: Message too long error when appending journal (issue#23545,
> issue#23526, pr#21216, Mykola Golub)
> * legal: remove doc license ambiguity (issue#23410, issue#23336,
> pr#20988, Nathan Cutler)
> * librados: make OPERATION_FULL_FORCE the default for rados_remove()
> (issue#23114, issue#22413, pr#20585, Kefu Chai)
> * librados/snap_set_diff: don't assert on empty snapset (issue#23423,
> pr#20991, Mykola Golub)
> * librbd: potential crash if object map check encounters error
> (issue#22857, issue#22819, pr#20253, Jason Dillaman)
> * log: Fix AddressSanitizer: new-delete-type-mismatch (issue#23324,
> issue#23412, pr#20998, Brad Hubbard)
> * mds: add uptime to MDS status (issue#23150, pr#20626, Patrick
> Donnelly)
> * mds: FAILED assert (p !=3D active_requests.end()) in MDRequestRef
> MDCache::request_get(metareqid_t) (issue#23154, issue#23059, pr#21176,
> "Yan, Zheng")
> * mds: fix session reference leak (issue#22821, issue#22969, pr#20432,
> "Yan, Zheng")
> * mds: optimize getattr file size (issue#23013, issue#22925, pr#20455,
> "Yan, Zheng")
> * mgr: Backport recent prometheus exporter changes (pr#20642, Jan
> Fajerski, Boris Ranto)
> * mgr: Backport recent prometheus rgw changes (pr#21492, Jan Fajerski,
> John Spray, Boris Ranto, Rubab-Syed)
> * mgr/balancer: pool-specific optimization support and bug fixes
> (pr#20359, xie xingguo)
> * mgr: die on bind() failure (issue#23175, pr#20712, John Spray)
> * mgr: fix MSG_MGR_MAP handling (issue#23409, pr#20973, Gu Zhongyan)
> * mgr: prometheus: fix PG state names (pr#21365, John Spray)
> * mgr: prometheus: set metadata metrics value to '1' (#22717) (pr#20254,
> Konstantin Shalygin)
> * mgr: quieten logging on missing OSD stats (issue#23224, pr#21053, John
> Spray)
> * mgr/zabbix: Backports to Luminous (pr#20781, Wido den Hollander)
> * mon: allow removal of tier of ec overwritable pool (issue#22971,
> issue#22754, pr#20433, Patrick Donnelly)
> * mon: ops get stuck in "resend forwarded message to leader"
> (issue#22114, issue#23077, pr#21016, Kefu Chai, Greg Farnum)
> * mon, osd: fix potential collided \*Up Set\* after PG remapping
> (issue#23118, pr#20829, xie xingguo)
> * mon/OSDMonitor.cc: fix expected_num_objects interpret error
> (issue#22530, issue#23315, pr#20907, Yang Honggang)
> * mon: update PaxosService::cached_first_committed in PaxosService::may=
=E2=80=A6
> (issue#23626, issue#11332, pr#21328, Xuehan Xu, yupeng chen)
> * msg/async: size of EventCenter::file_events should be greater than fd
> (issue#23253, issue#23306, pr#20867, Yupeng Chen)
> * Objecter: add ignore overlay flag if got redirect reply (pr#20766,
> Ting Yi Lin)
> * os/bluestore: avoid overhead of std::function in blob_t (pr#20674,
> Radoslaw Zarzynski)
> * os/bluestore: avoid unneeded BlobRefing in _do_read() (pr#20675,
> Radoslaw Zarzynski)
> * os/bluestore: backport fixes around _reap_collection (pr#20964,
> Jianpeng Ma)
> * os/bluestore: change the type of aio_t:res to long (issue#23527,
> issue#23544, pr#21231, kungf)
> * os/bluestore: _dump_onode() don't prolongate Onode anymore (pr#20676,
> Radoslaw Zarzynski)
> * os/bluestore: recalc_allocated() when decoding bluefs_fnode_t
> (issue#23256, issue#23212, pr#20771, Jianpeng Ma, Igor Fedotov, Kefu
> Chai)
> * os/bluestore: trim cache every 50ms (instead of 200ms) (issue#23226,
> pr#21059, Sage Weil)
> * osd: add numpg_removing metric (pr#20785, Sage Weil)
> * osdc/Journaler: make sure flush() writes enough data (issue#22967,
> issue#22824, pr#20431, "Yan, Zheng")
> * osd: do not release_reserved_pushes when requeuing (pr#21229, Sage
> Weil)
> * osd: Fix assert when checking missing version (issue#21218,
> issue#23024, pr#20495, David Zafman)
> * osd: objecter sends out of sync with pg epochs for proxied ops
> (issue#22123, issue#23075, pr#20609, Sage Weil)
> * osd/OSDMap: skip out/crush-out osds (pr#20840, xie xingguo)
> * osd/osd_types: fix pg_pool_t encoding for hammer (pr#21283, Sage Weil)
> * osd: remove cost from mclock op queues; cost not handled well in dmcl=
=E2=80=A6
> (pr#21426, J. Eric Ivancich)
> * osd: Remove partially created pg known as DNE (issue#23160,
> issue#21833, pr#20668, David Zafman)
> * osd: resend osd_pgtemp if it's not acked (issue#23610, issue#23630,
> pr#21330, Kefu Chai)
> * osd: treat successful and erroroneous writes the same for log trimming
> (issue#23323, issue#22050, pr#20851, Josh Durgin)
> * os/filestore: fix do_copy_range replay bug (issue#23351, issue#23298,
> pr#20957, Sage Weil)
> * parent blocks are still seen after a whole-object discard
> (issue#23304, issue#23285, pr#20860, Ilya Dryomov, Jason Dillaman)
> * PendingReleaseNotes: add note about upgrading MDS (issue#23414,
> pr#21001, Patrick Donnelly)
> * : qa: adjust cephfs full test for kclient (issue#22966, issue#22886,
> pr#20417, "Yan, Zheng")
> * qa: ignore io pause warnings in mds-full test (issue#23062,
> issue#22990, pr#20525, Patrick Donnelly)
> * qa: ignore MON_DOWN while thrashing mons (issue#23061, pr#20523,
> Patrick Donnelly)
> * qa/rgw: remove some civetweb overrides for beast testing (issue#23002,
> issue#23176, pr#20736, Casey Bodley)
> * qa: src/test/libcephfs/test.cc:376: Expected: (len) > (0), actual: -34
> vs 0 (issue#22383, issue#22221, pr#21173, Patrick Donnelly)
> * qa: synchronize kcephfs suites with fs/multimds (issue#22891,
> issue#22627, pr#20302, Patrick Donnelly)
> * qa/tests - added tag: v12.2.2 to be used by client.1 (pr#21452, Yuri
> Weinstein)
> * qa/tests - Change machine type from 'vps' to 'ovh' as 'vps' does not =
=E2=80=A6
> (pr#21031, Yuri Weinstein)
> * qa/workunits/rados/test-upgrade-to-mimic.sh: fix tee output (pr#21506,
> Sage Weil)
> * qa/workunits/rbd: switch devstack tempest to 17.2.0 tag (issue#23177,
> issue#22961, pr#20715, Jason Dillaman)
> * radosgw-admin data sync run crashes (issue#23180, pr#20762,
> lvshanchun)
> * rbd-mirror: fix potential infinite loop when formatting status message
> (issue#22964, issue#22932, pr#20416, Mykola Golub)
> * rbd-nbd: fix ebusy when do map (issue#23542, issue#23528, pr#21230, Li
> Wang)
> * rgw: add radosgw-admin sync error trim to trim sync error log
> (issue#23302, pr#20859, fang yuxiang)
> * rgw: add xml output header in RGWCopyObj_ObjStore_S3 response msg
> (issue#22416, issue#22635, pr#19883, Enming Zhang)
> * rgw: Admin API Support for bucket quota change (issue#23357,
> issue#21811, pr#20885, Jeegn Chen)
> * rgw: allow beast frontend to listen on specific IP address
> (issue#22858, issue#22778, pr#20252, Yuan Zhou)
> * rgw: can't download object with range when compression enabled
> (issue#23146, issue#23179, issue#22852, pr#20741, fang yuxiang)
> * rgw: data sync of versioned objects, note updating bi marker
> (issue#23025, pr#21214, Yehuda Sadeh)
> * RGW doesn't check time skew in auth v4 http header request
> (issue#23252, issue#22766, issue#22439, issue#22418, pr#20072, Bingyin
> Zhang, Casey Bodley)
> * rgw_file: avoid evaluating nullptr for readdir offset (issue#22889,
> pr#20345, Matt Benjamin)
> * rgw: fix crash with rgw_run_sync_thread false (issue#23318,
> issue#20448, pr#20932, Orit Wasserman)
> * rgw: fix memory fragmentation problem reading data from client
> (issue#23347, pr#20953, Marcus Watts)
> * rgw: fix mutlisite read-write issues (issue#23690, issue#22804,
> pr#21390, Niu Pengju)
> * rgw: fix the max-uploads parameter not work (issue#23020, issue#22825,
> pr#20476, Xin Liao)
> * rgw_log, rgw_file: account for new required envvars (issue#23192,
> issue#21942, pr#20672, Matt Benjamin)
> * rgw: log the right http status code in civetweb frontend's access log
> (issue#22812, issue#22538, pr#20157, Yao Zongyou)
> * rgw: parse old rgw_obj with namespace correctly (issue#23102,
> issue#22982, pr#20586, Yehuda Sadeh)
> * rgw recalculate stats option added (issue#23691, issue#23720,
> issue#23335, issue#23322, pr#21393, Abhishek Lekshmanan)
> * rgw: reject encrypted object COPY before supported (issue#23232,
> issue#23346, pr#20937, Jeegn Chen)
> * rgw: rgw: reshard cancel command should clear bucket resharding flag
> (issue#21619, pr#21389, Orit Wasserman)
> * rgw: s3website error handler uses original object name (issue#23201,
> issue#23310, pr#20889, Casey Bodley)
> * rgw: upldate the max-buckets when the quota is uploaded (issue#23022,
> pr#20477, zhaokun)
> * rgw: usage log fixes (issue#23686, issue#23758, pr#21388, Yehuda
> Sadeh, Greg Farnum, Robin H. Johnson)
> * rocksdb: incorporate the fix in RocksDB for no fast CRC32 path
> (issue#22534, pr#20825, Radoslaw Zarzynski)
> * scrub errors not cleared on replicas can cause inconsistent pg state
> when replica takes over primary (issue#23267, pr#21103, David Zafman)
> * snapmapper inconsistency, crash on luminous (issue#23500, pr#21118,
> Sage Weil)
> * Special scrub handling of hinfo_key errors (issue#23654, issue#23428,
> issue#23364, pr#21397, David Zafman)
> * src: s/--use-wheel// (pr#21177, Kefu Chai)
> * systemd: Wait 10 seconds before restarting ceph-mgr (issue#23083,
> issue#23101, pr#20604, Wido den Hollander)
> * test_admin_socket.sh may fail on wait_for_clean (issue#23507,
> pr#21124, Mykola Golub)
> * test/ceph-disk: specify the python used for creating venv
> (issue#23281, pr#20817, Kefu Chai)
> * TestLibRBD.RenameViaLockOwner may still fail with -ENOENT
> (issue#23152, issue#23068, pr#20628, Mykola Golub)
> * test/librbd: utilize unique pool for cache tier testing (issue#23064,
> issue#11502, pr#20550, Jason Dillaman)
> * test/pybind/test_rbd: allow v1 images for testing (pr#21471, Sage
> Weil)
> * test: Replace bc command with printf command (pr#21015, David Zafman)
> * tests: drop upgrade/jewel-x/point-to-point-x in luminous and master
> (issue#23159, issue#22888, pr#20641, Nathan Cutler)
> * tests: ENGINE Error in 'start' listener <bound  in rados (issue#23606,
> pr#21307, John Spray)
> * tests: rgw: swift tests target ceph-luminous branch (pr#21048, Nathan
> Cutler)
> * tests: unittest_pglog timeout (issue#23522, issue#23504, pr#21134,
> Nathan Cutler)
> * Update mgr/restful documentation (issue#23230, pr#20725, Boris Ranto)
>
> Getting Ceph
> ------------
> * Git at git://github.com/ceph/ceph.git
> * Tarball at http://download.ceph.com/tarballs/ceph-12.2.5.tar.gz
> * For packages, see
> http://docs.ceph.com/docs/master/install/get-packages/
> * For ceph-deploy, see
> http://docs.ceph.com/docs/master/install/install-ceph-deploy
> * Release git sha1: cad919881333ac92274171586c827e01f554a70a
> * Blog entry: https://ceph.com/releases/v12-2-5-luminous-released/
>
>  From the ceph devel community, we wish you a happy upgrade process.
>
> Best,
> Abhishek
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
